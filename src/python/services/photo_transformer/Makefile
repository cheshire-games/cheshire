FULL_IMAGE_NAME		:= 		"654654581568.dkr.ecr.us-east-1.amazonaws.com/photo-transformer:latest"

tests:
	. venv/bin/activate
	python -m pip install --upgrade pip setuptools wheel
	python -m pip install -r requirements.txt
	python -m pip install -r test-requirements.txt
	python -m pytest tests

build:
	docker build . -t "${REGISTRY}/${REPOSITORY}"

release:
	docker push "${REGISTRY}/${REPOSITORY}"
