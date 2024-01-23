import os
from pathlib import Path

from PIL import Image
from rembg import remove, new_session

from cheshire.photo_uploader import OUTPUT_IMAGE_EXTENSION, mkdir_override, ALLOWED_EXTENSIONS


def _get_alpha_matting_settings() -> dict:
    return (
        dict(alpha_matting=False) if os.environ.get("ALPHA_MATTING_ENABLED") == "false"
        else dict(alpha_matting=True, alpha_matting_erode_size=5)
    )


def remove_background(input_path: Path, output_directory: Path) -> Path:
    output_directory: Path = output_directory / "without_background"
    mkdir_override(directory_path=output_directory)

    session = new_session()
    for file in Path(input_path).glob("*"):
        if file.suffix in ALLOWED_EXTENSIONS:
            input_image = Image.open(str(file))
            input_image.thumbnail((500, 500))
            output_image = remove(
                data=input_image,
                session=session,
                **_get_alpha_matting_settings()
            )
            output_image_path = str(output_directory / f"{file.stem}{OUTPUT_IMAGE_EXTENSION}")
            output_image.save(output_image_path)
    return output_directory
