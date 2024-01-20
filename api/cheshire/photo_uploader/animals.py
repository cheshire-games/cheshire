import shutil
from functools import cache
from pathlib import Path

import cv2

from photo_uploader import mkdir_override, ALLOWED_EXTENSIONS


@cache
def get_cascade_classifiers() -> list[cv2.CascadeClassifier]:
    return [
        cv2.CascadeClassifier(str(cascade_file))
        for cascade_file in (Path("resources/cascades")).glob("*.xml")
    ]


def image_contains_animals(image: cv2.typing.MatLike) -> bool:
    for animal_cascade in get_cascade_classifiers():
        detected_objects = animal_cascade.detectMultiScale(
            image=image,
            scaleFactor=2,
            minNeighbors=1,
            minSize=(500, 500),
        )

        if len(detected_objects) > 0:
            return True
    return False


def filter_animals(input_path: Path, output_directory: Path) -> Path:
    output_directory: Path = output_directory / "only_animals"
    mkdir_override(directory_path=output_directory)

    for image_file in Path(input_path).glob("*"):
        if image_file.suffix in ALLOWED_EXTENSIONS:
            img = cv2.imread(str(image_file))
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            if image_contains_animals(gray):
                shutil.copyfile(src=image_file, dst=output_directory / f"{image_file.name}")
    return output_directory
