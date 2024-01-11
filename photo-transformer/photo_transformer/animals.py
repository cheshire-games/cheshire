from photo_transformer import EntityAttribute, validate_attributes


@validate_attributes(
    required_in_input=[EntityAttribute.PHOTO_BASE64],
    required_in_output=[EntityAttribute.PHOTO_BASE64],
)
def identify_animals_in_image(entity: dict) -> dict:
    pass
