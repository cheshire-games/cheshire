from pathlib import Path

import cv2

from cheshire.photo_uploader import mkdir_override, OUTPUT_IMAGE_EXTENSION, ALLOWED_EXTENSIONS


def resize_images(input_path: Path, output_directory: Path) -> Path:
    output_directory: Path = output_directory / "resized"
    mkdir_override(directory_path=output_directory)

    for file in Path(input_path).glob("*"):
        if file.suffix in ALLOWED_EXTENSIONS:
            image = cv2.imread(str(file), cv2.IMREAD_UNCHANGED)
            x, y, w, h = cv2.boundingRect(image[..., 3])
            resized_image = image[y : y + h, x : x + w, :]
            cv2.imwrite(
                str(output_directory / f"{file.stem}{OUTPUT_IMAGE_EXTENSION}"), resized_image
            )
    return output_directory
