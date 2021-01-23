PYTHON := python
PIP := $(PYTHON) -m pip
PIP_INSTALL := $(PIP) install --upgrade
COVERAGE := $(PYTHON) -m coverage
RM := rm -rf

.DEFAULT_GOAL := install

.PHONY: clean
clean: clean_coverage clean_distribution clean_docs clean_tests

.PHONY: clean_coverage
clean_coverage:
	@ $(RM) .coverage
	@ $(RM) coverage.xml

.PHONY: clean_distribution
clean_distribution:
	@ $(RM) build
	@ $(RM) dist
	@ $(RM) src/*.egg-info

.PHONY: clean_docs
clean_docs:
	@ $(RM) docs/build
	@ $(RM) docs/source/generated

.PHONY: clean_tests
clean_tests:
	@ $(RM) .pytest_cache

.PHONY: autodoc
autodoc:
	@ sphinx-apidoc --force --doc-project a-python-package --output-dir docs/source/generated src/foo

.PHONY: docs
docs: clean_docs
	@ sphinx-build docs/source docs/build -b html -W

.PHONY: install
install:
	@ $(PIP_INSTALL) .

.PHONY: install_extras
install_extras:
	@ $(PIP_INSTALL) pip
	@ $(PIP_INSTALL) setuptools wheel
	@ $(PIP_INSTALL) --editable .[lint,test,docs]

.PHONY: isort
isort:
	@ isort src

.PHONY: lint
lint:
	@ pylama src

.PHONY: test
test: clean_tests
	@ pytest tests

.PHONY: distribute
distribute: clean_distribution
	@ $(PIP_INSTALL) twine
	@ $(PYTHON) setup.py --quiet sdist bdist_wheel

.PHONY: publish
publish:
	@ twine upload dist/*
	# @ twine upload --repository testpypi dist/*

.PHONY: coverage
coverage: clean_coverage
	@ $(COVERAGE) run -m pytest tests
	@ $(COVERAGE) xml
	@ $(COVERAGE) report --show-missing

.PHONY: upload_coverage
upload_coverage: coverage
	@ bash <(curl -s https://codecov.io/bash) --verbose
