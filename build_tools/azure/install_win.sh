#!/bin/bash

set -e
set -x

# defines the get_dep and show_installed_libraries functions
source build_tools/shared.sh

if [[ "$DISTRIB" == "conda" ]]; then
    conda update -n base conda -y
    # TODO: update conda-lock version from time to time
    conda install pip -y
    pip install conda-lock==1.0.5
    conda-lock install --name $VIRTUALENV $LOCK_FILE
    source activate $VIRTUALENV
else
    python -m venv $VIRTUALENV
    source $VIRTUALENV/Scripts/activate
    pip install -r $LOCK_FILE
fi

show_installed_libraries

# Build scikit-learn
python setup.py bdist_wheel

# Install the generated wheel package to test it
pip install --pre --no-index --find-links dist scikit-learn
