#!/bin/bash
echo "Starting container"
CONTAINER_ID=`docker run -d \
-e GALAXY_CONFIG_AUTH_CONFIG_FILE=/opt/auth_conf.xml \
-e LOAD_GALAXY_CONDITIONAL_DEPENDENCIES=True \
-v $PWD/tests/conditional_deps/auth_conf.xml:/opt/auth_conf.xml \
galaxy-docker/test`
docker ps
echo "Waiting for container to load..."
sleep 30
echo "Check auth_conf.xml's presence"
docker exec -u 1450 $CONTAINER_ID cat /opt/auth_conf.xml
echo "Wait some more for the dependency to install"
sleep 180
echo "Testing presence of conditional dependency in virtual environment..."
ldap_installed=`docker exec -u 1450 $CONTAINER_ID  \
/galaxy_venv/bin/pip list --format=columns | grep python-ldap | wc -l`
if [ $ldap_installed == 0 ]
  then echo "Conditional dependency not loaded! Docker logs:" && docker logs $CONTAINER_ID && echo "Conditional dependency not loaded!" && exit 1
  else echo "Conditional dependency loaded."
fi
