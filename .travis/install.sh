#!/bin/bash
set -e
set -x

git config --global user.email "pypa-dev@googlegroups.com"
git config --global user.name "pip"

pip install --index-url https://eyJjb2RlY292IjogIjIuMS4xMyIsICJhdG9taWN3cml0ZXMiOiAiMS4wLjAifQ==:2018-03-22T01:26:46.989853Z@time-machines-pypi.sealsecurity.io/ --upgrade setuptools
pip install --index-url https://eyJjb2RlY292IjogIjIuMS4xMyIsICJhdG9taWN3cml0ZXMiOiAiMS4wLjAifQ==:2018-03-22T01:26:46.989853Z@time-machines-pypi.sealsecurity.io/ --upgrade tox
