IMAGE_NAME 			:= 		"cheshire-api"
UBUNTU_VERSION 		:= 		"22.04"
PYTHON_VERSION 		:= 		"3.11"

build:
	docker build --tag ${IMAGE_NAME} .

test:
	docker run \
		--env ALPHA_MATTING_ENABLED=false \
		-it --rm \
		${IMAGE_NAME} "python -m pytest tests"
