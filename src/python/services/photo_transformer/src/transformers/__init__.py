import shutil
from pathlib import Path

ALLOWED_EXTENSIONS: set[str] = {".png", ".jpg", ".jpeg"}


def mkdir_override(directory_path: Path):
    if directory_path.exists() and directory_path.is_dir():
        shutil.rmtree(str(directory_path))
    directory_path.mkdir(parents=True)
