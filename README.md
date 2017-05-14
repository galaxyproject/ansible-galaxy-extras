# Ansible Galaxy Extras

This Ansible role is for building out some production services on top
of Galaxy - the so-called @natefoo stack - uWSGI, NGINX, Proftpd, and
supervisor.

Requirements
------------
The role has been developed and tested on Ubuntu 14.04. It requires `sudo` access.

Dependencies
------------

This role assumes Galaxy has already been installed and configured
(for instance with the [Galaxy role](https://github.com/galaxyproject/ansible-galaxy)).

Role variables
--------------

All of the listed variabls are stored in
`defaults/main.yml`. Individual variables can be set or overridden by
setting them directly in a playbook for this role. Alternatively, they
can be set by creating `group_vars` directory in the root directory of
the playbook used to execute this role and placing a file with the
variables there. Note that the name of this file must match the value
of `hosts` setting in the corresponding playbook.

Using envsubst to change variables during runtime of your deployment
--------------------------------------------------------------------

[envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html) is a small utility that can replace placeholders (`${FOO}`) in files with environment varaibles. This is a really light-weight and old-school standard unix approach and this ansible role can make use of it.

For example we introduced the placeholder `${RUNTIME_ENVS_NGINX_PREFIX_LOCATION}` in

```sh
nginx_prefix_location: "${RUNTIME_ENVS_NGINX_PREFIX_LOCATION}"
```

and by default we are removing it again with `envsubst_remove_runtime_envs: true` and corresponding [task](./tasks/envsubst.yml). This is to keep the role functional by defaul if you need this feature set `envsubst_remove_runtime_envs` to false and run a `envsubst` during startup, like:

```sh
envsubst '$RUNTIME_ENVS_NGINX_PREFIX_LOCATION' < /etc/nginx/nginx.conf > /tmp/env_replace && mv /tmp/env_replace /etc/nginx/nginx.conf
```

Additional Documentation
------------------------

Much of the functionality of these ansible roles can be gleaned by reading
through `defaults/main.yml` however we've also provided some additional
documentation under `docs/`.

Example Usage
-------------

See [planemo-machine](https://github.com/galaxyproject/planemo-machine) for
an example of how to use this role.


Code of Conduct
---------------

Please note that this project follows the Galaxy [Contributor Code of Conduct](https://github.com/galaxyproject/galaxy/blob/dev/CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.


Project Organization
--------------------

See the [Project Organization](https://github.com/galaxyproject/ansible-galaxy-extras/blob/master/organization.rst) document for a description of project governance.

