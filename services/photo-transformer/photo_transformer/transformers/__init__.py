import shutil
from pathlib import Path


def mkdir_override(directory_path: Path):
    if directory_path.exists() and directory_path.is_dir():
        shutil.rmtree(str(directory_path))
    directory_path.mkdir(parents=True)
