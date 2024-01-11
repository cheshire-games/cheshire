import json
from typing import Callable

from aws_lambda_powertools.utilities.typing import LambdaContext

from photo_transformer import EntityAttribute
from photo_transformer.animals import identify_animals_in_image
from photo_transformer.background import remove_background_from_image
from photo_transformer.logger import logger
from photo_transformer.status import calculate_status, StatusCode

TRANSFORMERS: list[Callable] = [
    identify_animals_in_image,
    remove_background_from_image,
    calculate_status,
]


def lambda_handler(entity: dict, context: LambdaContext):
    transformed_entity = entity
    for transformer in TRANSFORMERS:
        logger.info(f"Running {transformer.__name__} transformer...")
        transformed_entity = transformer(transformed_entity)

    def extract_status_from_entity() -> int:
        status_code: StatusCode = transformed_entity[EntityAttribute.STATUS_CODE]
        return status_code.value

    response: dict = {
        "statusCode": extract_status_from_entity(),
        "headers": {"Content-Type": "*/*"},
        "body": json.dumps(transformed_entity),
    }
    return response
