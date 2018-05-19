#!/bin/bash

set -e

PLANEMO_MACHINE_DIR="${HOME}/planemo-machine-test"
git clone https://github.com/galaxyproject/planemo-machine $PLANEMO_MACHINE_DIR

( cd ${PLANEMO_MACHINE_DIR} && git submodule update --init )

# remove the submodule role
rm -rf ${PLANEMO_MACHINE_DIR}/roles/galaxyprojectdotorg.galaxy-extras/*

# Copy the ansible-playbook from this repo into the Docker roles directory and build the image.
cp -r ./* "${PLANEMO_MACHINE_DIR}/roles/galaxyprojectdotorg.galaxy-extras/"

cd "${PLANEMO_MACHINE_DIR}"
bash ci_test.sh
