IMAGE_NAME 			:= 		"pb-app"
UBUNTU_VERSION 		:= 		"22.04"
FLUTTER_VERSION 	:= 		"3.16.5"

build-images:
	docker build \
		--build-arg ubuntu_version=${UBUNTU_VERSION} \
		--build-arg flutter_version=${FLUTTER_VERSION} \
		--tag ${IMAGE_NAME} .

install-prod-requirements:
	pip install -r services/photo-uploader/photo_uploader/requirements.txt

install-test-requirements:
	pip install -r services/photo-uploader/tests/requirements.txt

install-requirements: install-prod-requirements install-test-requirements