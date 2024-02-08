from concurrent.futures import ThreadPoolExecutor
from functools import partial
from pathlib import Path
from concurrent import futures

from src.s3 import client, BUCKET_NAME
from src.logger import logger
from src import OUTPUT_IMAGE_EXTENSION


def upload_file(file_to_upload: Path, path_in_bucket: str):
    """Upload a file to from local to S3"""
    client.upload_file(
        filename=file_to_upload,
        bucket=BUCKET_NAME,
        key=f"{path_in_bucket}/{file_to_upload.name}",
    )


def get_files_in_directory(
    directory_path: Path,
) -> list[Path]:
    return [file for file in Path(directory_path).glob(OUTPUT_IMAGE_EXTENSION)]


def upload_images(directory_to_upload: Path, path_in_bucket: str) -> list[str]:
    """Uploading files to S3 is I/O bound -> ThreadPool is preferred"""
    uploaded_files = []
    with ThreadPoolExecutor() as executor:
        future_to_key = {
            executor.submit(
                partial(upload_file, path_in_bucket),
                key,
            ): key
            for key in get_files_in_directory(directory_path=directory_to_upload)
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
                uploaded_files.append(future_to_key[future])
    return uploaded_files
