#!/bin/bash
echo "Starting container"
docker run -d -p 8080:80 -p 8021:21 -p 8022:22 \
--name galaxy_test_container \
-e GALAXY_CONFIG_AUTH_CONFIG_FILE=config/auth_conf.xml \
-v $PWD/tests/conditional_deps/auth_conf.xml:/galaxy-central/config/auth_conf.xml \
--name galaxy-test \
galaxy-docker/test
docker ps
echo "Waiting for container to load..."
sleep 30
echo "Check auth_conf.xml's presence"
docker exec -u 1450 galaxy-test cat /galaxy-central/config/auth_conf.xml
echo "Wait some more for the dependency to install"
sleep 60
echo "Testing presence of conditional dependency in virtual environment..."
docker exec -u 1450 galaxy-test \
/galaxy_venv/bin/pip list --format=columns | grep python-ldap
if [$? == 0 ]
  then echo "Conditional dependency loaded."
  else echo "Conditional dependency not loaded!" && exit 1
fi
