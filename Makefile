PIP := pip
PYTHON := python
RM := rm --force --recursive

.PHONY: autodoc clean clean_distribution clean_docs clean_tests docs distribute install install_extras isort lint test upload_codecov upload_testpypi

autodoc:
	@ sphinx-apidoc --force --doc-project a-python-package --output-dir docs/source src/foo

clean: clean_distribution clean_docs clean_tests

clean_distribution:
	@ $(RM) build
	@ $(RM) dist
	@ $(RM) src/*.egg-info

clean_docs:
	@ $(RM) docs/build

clean_tests:
	@ $(RM) .pytest_cache
	@ $(RM) .coverage

distribute: clean_distribution
	@ $(PIP) install --upgrade twine
	@ $(PYTHON) setup.py --quiet sdist bdist_wheel

docs: clean_docs
	@ sphinx-build docs/source docs/build -b html -W

install:
	@ $(PIP) install --upgrade .

install_extras:
	@ $(PIP) install --upgrade pip
	@ $(PIP) install --upgrade setuptools wheel
	@ $(PIP) install --upgrade --editable .[lint]
	@ $(PIP) install --upgrade --editable .[test]
	@ $(PIP) install --upgrade --editable .[docs]

isort:
	@ isort src

lint:
	@ pylama src

test: clean_tests
	@ pytest tests
	@ coverage run -m pytest tests
	@ coverage report --show-missing

upload_codecov:
	@ bash <(curl -s https://codecov.io/bash) -v

upload_testpypi:
	@ twine upload --repository testpypi dist/*
