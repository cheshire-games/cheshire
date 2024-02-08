from pathlib import Path

from src.runner import transform_images


def test_transform_images():
    input_path: Path = Path("resources/images")
    output_path: Path = transform_images(
        download_path=input_path, transform_directory=input_path / "generated"
    )
    assert Path(output_path).exists()
