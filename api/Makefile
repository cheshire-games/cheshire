IMAGE_NAME 			:= 		"pb-api"
UBUNTU_VERSION 		:= 		"22.04"
PYTHON_VERSION 		:= 		"3.12"

test:
	docker-compose up -d
	docker-compose down

build:
	docker build \
		--build-arg ubuntu_version=${UBUNTU_VERSION} \
		--build-arg python_version=${PYTHON_VERSION} \
		--tag ${IMAGE_NAME} .

install-requirements:
	pip install -r requirements.txt
