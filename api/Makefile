IMAGE_NAME 			:= 		"butterfly-api"
ALPINE_VERSION 		:= 		"3.19"
PYTHON_VERSION 		:= 		"3.11.7"

test:
	docker-compose up -d
	docker-compose down

build:
	docker build \
		--build-arg alpine_version=${ALPINE_VERSION} \
		--build-arg python_version=${PYTHON_VERSION} \
		--tag ${IMAGE_NAME} .

install-deps:
	pip install -r requirements.txt
