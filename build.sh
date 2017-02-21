#!/bin/bash -e

# Container short cut for running `pip install` with appropriate options
#
# This is partially a workaround for pre Docker 1.11 handling of build args
# and partially a better encapsulation of our build process.

if [ "$1" = "FREEZE" ]; then
    # during releases, freeze requirements
    pip install --upgrade --find-links /dist -r requirements.txt
else
    # outside of releases, use latest requirements
    pip install --upgrade --find-links /dist -e .
fi
