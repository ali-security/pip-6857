#!/bin/bash
set -e
set -x

git config --global user.email "pypa-dev@googlegroups.com"
git config --global user.name "pip"
git config --global url."https://github.com/".insteadOf "git://github.com/"

pip install --upgrade setuptools
pip install --upgrade tox
