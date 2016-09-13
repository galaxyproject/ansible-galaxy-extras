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
(for instance with the [Galaxy
role](https://github.com/galaxyproject/ansible-galaxy)).

Role variables
--------------

All of the listed variabls are stored in
`defaults/main.yml`. Individual variables can be set or overridden by
setting them directly in a playbook for this role. Alternatively, they
can be set by creating `group_vars` directory in the root directory of
the playbook used to execute this role and placing a file with the
variables there. Note that the name of this file must match the value
of `hosts` setting in the corresponding playbook.

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

