IMAGE_NAME 			:= 		"cheshire-api"
UBUNTU_VERSION 		:= 		"22.04"
PYTHON_VERSION 		:= 		"3.11"

ci-test:
	python -m pip install --upgrade pip setuptools wheel
	python -m pip install -r requirements.txt
	python -m pip install -r dev-requirements.txt
	python -m pytest tests
