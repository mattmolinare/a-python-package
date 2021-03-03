PACKAGE_NAME := a-python-package
PYTHON := python
PIP := $(PYTHON) -m pip
PIP_INSTALL := $(PIP) install --upgrade
COVERAGE := $(PYTHON) -m coverage
RM := rm -rf
CONDA := conda

.DEFAULT_GOAL := install

.PHONY: install
install:
	@ $(PIP_INSTALL) pip
	@ $(PIP_INSTALL) setuptools wheel
	@ $(PIP_INSTALL) .

.PHONY: clean_docs
clean_docs:
	@ $(RM) docs/build
	@ $(RM) docs/source/generated

.PHONY: autodoc
autodoc:
	@ sphinx-apidoc --force --doc-project $(PACKAGE_NAME) --output-dir docs/source/generated src

.PHONY: docs
docs: clean_docs
	@ sphinx-build docs/source docs/build -b html -W

.PHONY: clean_tests
clean_tests:
	@ $(RM) .pytest_cache

.PHONY: test
test: clean_tests
	@ pytest tests

.PHONY: isort
isort:
	@ isort src

.PHONY: clean_lint
clean_lint:
	@ $(RM) .mypy_cache

.PHONY: lint
lint: clean_lint
	@ pylama src

.PHONY: clean_coverage
clean_coverage:
	@ $(RM) .coverage
	@ $(RM) coverage.xml

.PHONY: coverage
coverage: clean_coverage
	@ $(COVERAGE) run -m pytest tests
	@ $(COVERAGE) xml
	@ $(COVERAGE) report --show-missing

.PHONY: upload_coverage
upload_coverage: coverage
	@ bash <(curl -s https://codecov.io/bash) --verbose

.PHONY: clean_pypi
clean_pypi:
	@ $(RM) build
	@ $(RM) dist
	@ $(RM) src/*.egg-info

.PHONY: distribute_pypi
distribute_pypi: clean_pypi
	@ $(PYTHON) setup.py --quiet sdist bdist_wheel

.PHONY: publish_pypi
publish_pypi:
	@ $(PIP_INSTALL) twine
	@ twine upload dist/*

.PHONY: clean_anaconda
clean_anaconda:
	@ $(RM) .conda_cache

.PHONY: distribute_anaconda
distribute_anaconda: clean_anaconda
	@ $(CONDA) install conda-build
	@ $(CONDA) skeleton pypi $(PACKAGE_NAME) --output-dir .conda_cache/recipes
	@ conda-build -c defaults -c conda-forge .conda_cache/recipes/$(PACKAGE_NAME)

.PHONY: publish_anaconda
publish_anaconda:
	@ $(CONDA) install anaconda-client
	@ anaconda upload $$(conda-build .conda_cache/recipes/$(PACKAGE_NAME) --output) --all --skip-existing

.PHONY: clean
clean: clean_docs clean_tests clean_lint clean_coverage clean_pypi clean_anaconda
