PYTHON := python
PIP := $(PYTHON) -m pip
PIP_INSTALL := $(PIP) install --upgrade
RM := rm --force --recursive
COVERAGE := $(PYTHON) -m coverage

.PHONY: autodoc clean clean_coverage clean_distribution clean_docs clean_tests coverage docs distribute install install_extras isort lint publish test upload_coverage

autodoc:
	@ sphinx-apidoc --force --doc-project a-python-package --output-dir docs/source src/foo

clean: clean_coverage clean_distribution clean_docs clean_tests

clean_coverage:
	@ $(RM) .coverage
	@ $(RM) coverage.xml

clean_distribution:
	@ $(RM) build
	@ $(RM) dist
	@ $(RM) src/*.egg-info

clean_docs:
	@ $(RM) docs/build

clean_tests:
	@ $(RM) .pytest_cache

coverage: clean_coverage
	@ $(COVERAGE) run -m pytest tests
	@ $(COVERAGE) xml
	@ $(COVERAGE) report --show-missing

distribute: clean_distribution
	@ $(PIP_INSTALL) twine
	@ $(PYTHON) setup.py --quiet sdist bdist_wheel

docs: clean_docs
	@ sphinx-build docs/source docs/build -b html -W

install:
	@ $(PIP_INSTALL) .

install_extras:
	@ $(PIP_INSTALL) pip
	@ $(PIP_INSTALL) setuptools wheel
	@ $(PIP_INSTALL) --editable .[lint]
	@ $(PIP_INSTALL) --editable .[test]
	@ $(PIP_INSTALL) --editable .[docs]

isort:
	@ isort src

lint:
	@ pylama src

publish:
	@ twine upload dist/*
	# @ twine upload --repository testpypi dist/*

test: clean_tests
	@ pytest tests

upload_coverage: coverage
	@ bash <(curl -s https://codecov.io/bash) --verbose
