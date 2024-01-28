from pathlib import Path

from cheshire.photos.s3_utils.downloader import download_images
from cheshire.photos.s3_utils.uploader import upload_images
from cheshire.photos.upload.animals import filter_animals
from cheshire.photos.upload.background import remove_background
from cheshire.photos.upload.resize import resize_images


def _download_images(user_id: str, upload_id: str) -> tuple[Path, int]:
    return download_images(
        download_path=Path(f"generated/{user_id}/uploads/{upload_id}"),
        path_in_bucket=f"{user_id}/{upload_id}/"
    )


def transform_images(download_path: Path, transform_directory: Path) -> Path:
    assert download_path.exists()
    current_path: Path = download_path

    for step in [
        filter_animals,
        remove_background,
        resize_images,
    ]:
        current_path = step(
            input_path=current_path,
            output_directory=transform_directory,
        )
    return current_path


def _upload_images(directory_to_upload: Path, user_id: str):
    return upload_images(
        directory_to_upload=directory_to_upload,
        path_in_bucket=f"{user_id}/images"
    )


async def run(user_id: str, upload_id: str):
    download_path, downloaded_cnt = _download_images(
        user_id=user_id,
        upload_id=upload_id,
    )
    directory_to_upload: Path = transform_images(
        download_path=download_path, transform_directory=download_path / "generated"
    )
    uploaded_cnt = _upload_images(
        directory_to_upload=directory_to_upload,
        user_id=user_id,
    )
