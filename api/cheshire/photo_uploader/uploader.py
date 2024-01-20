from concurrent.futures import ThreadPoolExecutor
from functools import partial
from pathlib import Path
from concurrent import futures

import boto3

from logger import logger
from photo_uploader import (
    OUTPUT_IMAGE_EXTENSION,
    BUCKET_NAME,
)


def upload_file(file_to_upload: Path, user_id: str, upload_id: str):
    """Upload a file to from local to S3"""
    s3_client = boto3.client("s3")
    s3_path: str = f"{user_id}/images/{upload_id}_{file_to_upload.name}"
    logger.info(f"Uploading {file_to_upload} to {s3_path}")
    s3_client.upload_file(
        filename=file_to_upload,
        bucket=BUCKET_NAME,
        key=s3_path,
    )


def get_files_in_directory(
    directory_path: Path,
) -> list[Path]:
    return [file for file in Path(directory_path).rglob(OUTPUT_IMAGE_EXTENSION)]


def upload_images(directory_to_upload: Path, user_id: str, upload_id: str) -> int:
    """Uploading files to S3 is I/O bound -> ThreadPool is preferred"""
    uploaded_cnt = 0
    with ThreadPoolExecutor() as executor:
        future_to_key = {
            executor.submit(
                partial(upload_file, user_id, upload_id),
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
                uploaded_cnt += 1
    return uploaded_cnt
