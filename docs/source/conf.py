#!/usr/bin/python

import inspect
import os
import subprocess
import sys

import foo

project = foo.__package__
author = foo.__author__
copyright = foo.__copyright__
version = foo.__version__
release = version

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.intersphinx',
    'sphinx.ext.linkcode',
    'sphinx.ext.mathjax',
    'numpydoc'
]

autodoc_typehints = 'none'

intersphinx_mapping = {
    'python': ('https://docs.python.org/dev/', None),
    'numpy': ('https://numpy.org/doc/stable/', None)
}

numpydoc_xref_param_type = True
numpydoc_xref_ignore = {
    'or',
    'optional'
}
numpydoc_xref_aliases = {
    'ndarray': 'numpy.ndarray',
    'array_like': ':term:`numpy:array_like`'
}

master_doc = 'index'

templates_path = [
    '_templates'
]

exclude_patterns = [
    '_build'
]

html_theme = 'sphinx_rtd_theme'
html_theme_options = {
}

html_static_path = [
    '_static'
]


def _get_revision():
    try:
        process = subprocess.run(['git', 'rev-parse', '--short', 'HEAD'],
                                 capture_output=True, check=True, text=True)
        return process.stdout.strip()
    except subprocess.CalledProcessError:
        return 'main'


_revision = _get_revision()


def linkcode_resolve(domain, info):

    if domain != 'py':
        return None

    # Get module.
    module_name = info['module']
    if not module_name:
        return None
    module = sys.modules.get(module_name)
    if module is None:
        return None

    # Get object.
    obj_name = info['fullname']
    obj = module
    for attr in obj_name.split('.'):
        try:
            obj = getattr(obj, attr)
        except Exception:
            return None
        if isinstance(obj, property):
            obj = obj.fget
        while hasattr(obj, '__wrapped__'):
            obj = obj.__wrapped__

    # Get source file path relative to package directory.
    file = inspect.getsourcefile(obj)
    if file is None:
        return None
    package_dir = os.path.dirname(foo.__file__)
    if os.path.commonpath([file, package_dir]) != package_dir:
        return None
    file = os.path.relpath(file, start=package_dir)

    # Get source line specification.
    lines, first_line_no = inspect.getsourcelines(obj)
    last_line_no = first_line_no + len(lines) - 1
    line_spec = f'#L{first_line_no}-L{last_line_no}'

    return f'{foo.__url__}/blob/{_revision}/src/foo/{file}/{line_spec}'
