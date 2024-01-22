IMAGE_NAME 			:= 		"cheshire-base"
UBUNTU_VERSION 		:= 		"22.04"
FLUTTER_VERSION 	:= 		"3.16.5"
PYTHON_VERSION 		:= 		"3.11"

build:
	docker build \
		--build-arg ubuntu_version=${UBUNTU_VERSION} \
		--build-arg flutter_version=${FLUTTER_VERSION} \
		--build-arg python_version=${PYTHON_VERSION} \
		--tag ${IMAGE_NAME} .
