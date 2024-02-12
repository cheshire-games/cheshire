from pathlib import Path

from src.s3.downloader import download_images
from src.s3.uploader import upload_images
from src.transformers.animals import filter_animals
from src.transformers.background import remove_background
from src.transformers.resize import resize_images


def _download_images(user_id: str, upload_id: str) -> tuple[Path, list[str]]:
    return download_images(
        download_path=Path(f"generated/{user_id}/uploads/{upload_id}"),
        path_in_bucket=f"{user_id}/{upload_id}/",
    )


def transform_images(download_path: Path, transform_directory: Path) -> Path:
    print("CWD: " + str(Path.cwd()))
    download_path.mkdir(exist_ok=True)
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


def _upload_images(directory_to_upload: Path, user_id: str) -> list[str]:
    return upload_images(directory_to_upload=directory_to_upload, path_in_bucket=f"{user_id}/images")


def _map_downloaded_to_uploaded_files(downloaded_files: list[str], uploaded_files: list[str]) -> dict[str, list[str]]:
    downloaded_to_uploaded = dict()
    for downloaded_file in downloaded_files:
        for uploaded_file in uploaded_files:
            if Path(downloaded_file).stem == Path(uploaded_file).stem:
                if downloaded_file not in downloaded_to_uploaded:
                    downloaded_to_uploaded[downloaded_file] = []
                downloaded_to_uploaded[downloaded_file].append(uploaded_file)
    return downloaded_to_uploaded


def run(user_id: str, upload_id: str) -> dict:
    download_path, downloaded_files = _download_images(
        user_id=user_id,
        upload_id=upload_id,
    )
    directory_to_upload: Path = transform_images(
        download_path=download_path, transform_directory=download_path / "generated"
    )
    uploaded_files = _upload_images(
        directory_to_upload=directory_to_upload,
        user_id=user_id,
    )
    return dict(
        user_id=user_id,
        upload_id=upload_id,
        downloaded_files=downloaded_files,
        uploaded_files=uploaded_files,
    )
