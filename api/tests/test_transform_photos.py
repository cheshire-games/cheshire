from pathlib import Path

import photo_uploader.runner as photo_uploader


def test_transform_photos():
    input_path: Path = Path("resources/images")
    output_path: Path = photo_uploader.transform_images(
        download_path=input_path,
        transform_directory=input_path / "generated"
    )
    assert str(output_path).startswith("resources/images/generated")
