IMAGE_NAME 			:= 		"princess-peanutbutter"
UBUNTU_VERSION 		:= 		"22.04"
FLUTTER_VERSION 	:= 		"3.16.5"

build-images:
	docker build \
		--build-arg ubuntu_version=${UBUNTU_VERSION} \
		--build-arg flutter_version=${FLUTTER_VERSION} \
		--tag ${IMAGE_NAME} .
