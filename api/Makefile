IMAGE_NAME 			:= 		"cheshire-api"
UBUNTU_VERSION 		:= 		"22.04"
PYTHON_VERSION 		:= 		"3.11"

build:
	docker build \
		--build-arg ubuntu_version=${UBUNTU_VERSION} \
		--build-arg python_version=${PYTHON_VERSION} \
		--tag ${IMAGE_NAME} .

test:
	docker run -it --rm ${IMAGE_NAME} \
		"python -m pytest /app/tests"

install-deps:
	pip install -r requirements.txt
