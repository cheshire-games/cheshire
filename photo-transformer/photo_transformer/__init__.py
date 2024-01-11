from enum import Enum


class EntityAttribute(Enum):
    PHOTO_BASE64 = "photo-base64"
    ANIMALS_COUNT = "animals-count"
    STATUS_CODE = "status-code"


def validate_attributes(
        required_in_input: list[EntityAttribute], required_in_output: list[EntityAttribute]
):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for attr in {attr.value for attr in required_in_input}:
                input_entity = args[0]
                assert (
                        attr in input_entity
                ), f"Required attribute {attr} is missing from input entity"
            output_entity = func(*args, **kwargs)
            for attr in {attr.value for attr in required_in_output}:
                assert (
                        attr in output_entity
                ), f"Required attribute {attr} is missing from output entity"
            return output_entity

        return wrapper

    return decorator
