IMAGE_NAME 			:= 		"cheshire-api"
UBUNTU_VERSION 		:= 		"22.04"
PYTHON_VERSION 		:= 		"3.11"

build:
	docker build --tag ${IMAGE_NAME} .

test:
	docker run -it --rm ${IMAGE_NAME} \
		"python -m pytest /app/tests"

install-deps:
	pip install -r requirements.txt
