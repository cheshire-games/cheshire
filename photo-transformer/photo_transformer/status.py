from enum import Enum

from photo_transformer import validate_attributes, EntityAttribute


class StatusCode(Enum):
    PHOTO_VALID = 200
    PHOTO_MISSING_ANIMALS = 201
    PHOTO_TOO_MANY_ANIMALS = 202


@validate_attributes(
    required_in_input=[EntityAttribute.PHOTO_BASE64, EntityAttribute.ANIMALS_COUNT],
    required_in_output=[EntityAttribute.STATUS_CODE],
)
def calculate_status(entity: dict) -> dict:
    return dict()
