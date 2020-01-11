#!/usr/bin/env bash
set -e
export GALAXY_USER="admin@galaxy.org"
export GALAXY_USER_EMAIL="admin@galaxy.org"
export GALAXY_USER_PASSWD="admin"
export GALAXY_HOME=/home/galaxy
export GALAXY_TRAVIS_USER=galaxy
export GALAXY_UID=1450
export GALAXY_GID=1450
export BIOBLEND_GALAXY_API_KEY=admin
export BIOBLEND_GALAXY_URL=http://127.0.0.1:80
export BIOBLEND_TEST_JOB_TIMEOUT=240

sudo /etc/init.d/postgresql stop
sudo apt-get -y --purge remove postgresql libpq-dev libpq5 postgresql-client-common postgresql-common
sudo rm -rf /var/lib/postgresql

git clone http://github.com/artbio/galaxykickstart $HOME/galaxykickstart
pip install ansible==2.7.4
ansible-galaxy install -r $HOME/galaxykickstart/upstream_requirements_roles.yml \
  -p $HOME/galaxykickstart/roles -f
# remove ansible-galaxy-extras for testing
rm -rf $HOME/galaxykickstart/roles/galaxyprojectdotorg.galaxy-extras/*
cp -r ./* $HOME/galaxykickstart/roles/galaxyprojectdotorg.galaxy-extras/

# install and update galaxykickstart with ansible
ansible-playbook -i $HOME/galaxykickstart/inventory_files/galaxy-kickstart $HOME/galaxykickstart/galaxy.yml

sudo supervisorctl status
curl http://localhost:80/api/version| grep version_major
curl --fail $BIOBLEND_GALAXY_URL/api/version
date > $HOME/date.txt && curl --fail -T $HOME/date.txt ftp://127.0.0.1:21 --user $GALAXY_USER:$GALAXY_USER_PASSWD

# install bioblend testing, GKS way.
pip --version
sudo rm -f /etc/boto.cfg
sudo su $GALAXY_TRAVIS_USER -c 'pip install --ignore-installed --user https://github.com/galaxyproject/bioblend/archive/master.zip pytest'


sudo -E su $GALAXY_TRAVIS_USER -c "export PATH=$GALAXY_HOME/.local/bin/:$PATH &&
cd $GALAXY_HOME &&
bioblend-galaxy-tests -v -k \
         'not test_invocation and \
          not test_update_dataset_tags and \
          not test_upload_file_contents_with_tags and \
          not test_show_workflow_versions' $GALAXY_HOME/.local/lib/python2.7/site-packages/bioblend/_tests/TestGalaxy*.py"
cd $TRAVIS_BUILD_DIR
