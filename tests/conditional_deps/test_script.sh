#!/bin/bash
docker run -d -p 8080:80 -p 8021:21 -p 8022:22 \
--name galaxy_test_container \
-e GALAXY_CONFIG_AUTH_CONFIG_FILE=config/auth_conf.xml \
-v tests/conditional_deps/auth_conf.xml:/galaxy-central/config/auth_conf.xml \
--name galaxy-test \
galaxy-docker/test
docker ps
sleep 30
docker exec -u 1450 galaxy-test \
/galaxy_venv/bin/pip list --format=columns | grep python-ldap
if [$? == 0 ]
  then echo "Conditional dependency loaded"
  else echo "Conditional dependency not loaded!" && exit 1
fi
