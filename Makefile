SHELL := /bin/bash

tests:
	$(MAKE) tests -C src/python

build:
	$(MAKE) build -C src/python
