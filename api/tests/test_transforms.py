from pathlib import Path

from cheshire.photo_uploader.runner import transform_images


def test_transform_images():
    input_path: Path = Path("resources/images")
    output_path: Path = transform_images(
        download_path=input_path,
        transform_directory=input_path / "generated"
    )
    assert str(output_path).startswith("resources/images/generated")
