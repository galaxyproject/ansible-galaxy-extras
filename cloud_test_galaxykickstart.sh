#!/usr/bin/env bash
set -e

/usr/local/bin/pip install --ignore-installed ansible==2.7.4 && ansible --version

# Add ansible.cfg to pick up roles path.
printf '[defaults]\nroles_path = ../' > ansible.cfg

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

# remove postgresql if present
if service --status-all | grep -Fq 'postgres'; then
    sudo /etc/init.d/postgresql stop
    sudo apt-get -y --purge remove postgresql libpq-dev libpq5 postgresql-client-common postgresql-common
    sudo rm -rf /var/lib/postgresql
fi

if [[ ! -d /home/galaxy ]]
then
    sudo groupadd -r $GALAXY_TRAVIS_USER -g $GALAXY_GID
    sudo useradd -u $GALAXY_UID -r -g $GALAXY_TRAVIS_USER -d $GALAXY_HOME -p travis_testing -c "Galaxy user" $GALAXY_TRAVIS_USER
    sudo mkdir $GALAXY_HOME
    sudo chown -R $GALAXY_TRAVIS_USER:$GALAXY_TRAVIS_USER $GALAXY_HOME
fi

if [[ ! -d $HOME/galaxykickstart ]]
then
    git clone http://github.com/artbio/galaxykickstart -b test_19.09 $HOME/galaxykickstart
else
   git -C $HOME/galaxykickstart pull origin test_19.09 
fi

ansible-galaxy install -r $HOME/galaxykickstart/upstream_requirements_roles.yml \
  -p $HOME/galaxykickstart/roles -f

# remove ansible-galaxy-extras for testing
rm -rf $HOME/galaxykickstart/roles/galaxyprojectdotorg.galaxy-extras/*
cp -r ./* $HOME/galaxykickstart/roles/galaxyprojectdotorg.galaxy-extras/

# install and update galaxykickstart with ansible
ansible-playbook -i $HOME/galaxykickstart/inventory_files/galaxy-kickstart $HOME/galaxykickstart/galaxy.yml
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
bioblend-galaxy-tests -v -k 'not download_dataset and \
              not download_history and \
              not export_and_download and \
              not test_show_nonexistent_dataset and \
              not test_invocation and \
              not test_update_dataset_tags and \
              not test_upload_file_contents_with_tags and \
              not test_create_local_user and \
              not test_show_workflow_versions' $GALAXY_HOME/.local/lib/python2.7/site-packages/bioblend/_tests/TestGalaxy*.py"
cd $TRAVIS_BUILD_DIR
