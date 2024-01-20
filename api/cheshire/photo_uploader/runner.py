from pathlib import Path

from photo_uploader.animals import filter_animals
from photo_uploader.background import remove_background
from photo_uploader.downloader import download_images
from photo_uploader.resize import resize_images
from photo_uploader.split import split_images
from photo_uploader.uploader import upload_images


def transform_images(download_path: Path, transform_directory: Path) -> Path:
    assert download_path.exists()
    current_path: Path = download_path

    for step in [
        filter_animals,
        remove_background,
        resize_images,
        # split_images
    ]:
        current_path = step(
            input_path=current_path,
            output_directory=transform_directory,
        )
    return current_path


def run(user_id: str, upload_id: str) -> dict:
    download_path, downloaded_cnt = download_images(
        user_id=user_id,
        upload_id=upload_id,
    )
    directory_to_upload: Path = transform_images(
        download_path=download_path, transform_directory=download_path / "generated"
    )
    uploaded_cnt = upload_images(
        directory_to_upload=directory_to_upload,
        user_id=user_id,
        upload_id=upload_id,
    )

    return {
        "message": f"Transformed {downloaded_cnt} images, uploaded {uploaded_cnt} images",
        "images": {
            "input": downloaded_cnt,
            "output": uploaded_cnt,
        },
    }
