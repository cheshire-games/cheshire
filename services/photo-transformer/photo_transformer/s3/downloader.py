from concurrent import futures
from concurrent.futures import ThreadPoolExecutor
from functools import partial
from pathlib import Path
import boto3

from photo_transformer.logger import logger
from photo_transformer.s3 import client
from photo_transformer.transformers import BUCKET_NAME, MAX_PHOTOS_TO_HANDLE


def download_object(download_directory: Path, file_name: str) -> str:
    """Downloads an object from S3 to local"""
    download_path = str(download_directory / file_name)
    logger.info(f"Downloading {file_name} to {download_path}")
    client.download_file(
        bucket=BUCKET_NAME,
        key=file_name,
        filename=download_path,
    )
    return download_path


def get_keys_to_process(path_in_bucket: str) -> list[str]:
    bucket_obj = boto3.resource("s3").Bucket(BUCKET_NAME)
    s3_keys: list[str] = [obj.key for obj in bucket_obj.objects.filter(Prefix=path_in_bucket)]
    if len(s3_keys) <= MAX_PHOTOS_TO_HANDLE:
        logger.warning(
            f"Upload path {path_in_bucket} contains {len(s3_keys)} files, exceeding {MAX_PHOTOS_TO_HANDLE} - "
            f"processing {MAX_PHOTOS_TO_HANDLE} of the photos in random"
        )
        s3_keys = s3_keys[:MAX_PHOTOS_TO_HANDLE]
    return s3_keys


def download_images(download_path: Path, path_in_bucket: str) -> tuple[Path, int]:
    """Downloading files from S3 is I/O bound -> ThreadPool is preferred"""
    download_path.mkdir(parents=True)
    downloaded_cnt = 0
    with ThreadPoolExecutor() as executor:
        future_to_key = {
            executor.submit(partial(download_object, download_path), key): key
            for key in get_keys_to_process(path_in_bucket=path_in_bucket)
        }
        for future in futures.as_completed(future_to_key):
            exception = future.exception()
            if exception:
                try:
                    raise exception
                except Exception as e:
                    # TODO add tracing
                    logger.exception(e)
            else:
                downloaded_cnt += 1
    return download_path, downloaded_cnt
