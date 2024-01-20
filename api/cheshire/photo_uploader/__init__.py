import shutil
from pathlib import Path

BUCKET_NAME = "my-test-bucket"  # TODO change
OUTPUT_IMAGE_EXTENSION = ".png"
ALLOWED_EXTENSIONS: set[str] = {".png", ".jpg", ".jpeg"}


def mkdir_override(directory_path: Path):
    if directory_path.exists() and directory_path.is_dir():
        shutil.rmtree(str(directory_path))
    directory_path.mkdir()
