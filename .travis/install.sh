#!/bin/bash
set -e
set -x

git config --global user.email "pypa-dev@googlegroups.com"
git config --global user.name "pip"

pip install --force-reinstall --upgrade setuptools
pip install --force-reinstall --upgrade tox
