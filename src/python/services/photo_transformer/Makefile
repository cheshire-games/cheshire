IMAGE_NAME 			:= 		"photo-transformer"

tests:
	. venv/bin/activate
	python -m pip install --upgrade pip setuptools wheel
	python -m pip install -r requirements.txt
	python -m pip install -r test-requirements.txt
	python -m pytest tests

build:
	docker build . -t "${IMAGE_NAME}"
