#!/bin/bash

set -e

# this failed because galaxy-postgresql is not recursively imported
# mkdir $HOME/galaxy-docker
# wget -q -O - https://github.com/bgruening/docker-galaxy-stable/archive/master.tar.gz | tar xzf - --strip-components=1 -C $HOME/galaxy-docker

git clone --recursive https://github.com/bgruening/docker-galaxy-stable $HOME/galaxy-docker

# remove the submodule role
rm $HOME/galaxy-docker/galaxy/roles/galaxyprojectdotorg.galaxyextras/* -rf
wget https://raw.githubusercontent.com/galaxyproject/galaxy-flavor-testing/master/Makefile -O $HOME/galaxy-docker/Makefile

# install BioBlend
make install -f $HOME/galaxy-docker/Makefile

# Check the role/playbook's syntax.
ansible-playbook -i "localhost," tests/syntax.yml --syntax-check
# Copy the ansible-playbook from this repo into the Docker roles directory and build the image.
cp -r ./* $HOME/galaxy-docker/galaxy/roles/galaxyprojectdotorg.galaxyextras/
ls -l $HOME/galaxy-docker/galaxy/roles/galaxyprojectdotorg.galaxyextras/
cd $HOME/galaxy-docker/ && docker build -t galaxy-docker/test ./galaxy/
# run various tests against the container
make docker_run
sleep 30
make test_api
make test_ftp
make test_bioblend

# Test the conditional loading of dependencies.
cd $HOME/galaxy-docker/galaxy/roles/galaxyprojectdotorg.galaxyextras/
bash tests/conditional_deps/test_script.sh
