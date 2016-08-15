# HTTPS on Galaxy via LetsEncrypt

### Introduction

HTTPS is basically encrypted HTTP. Instead of port 80 it uses port 443. For
HTTP-based (drag/drop) uploads and downloads into/from galaxy of sensitive
clinical data, HTTPS necessary to meet common data protection standards (e.g. HIPAA).
We have added an easy way to set up and configure HTTPS with automatic certificate
authority [LetsEncrypt](https://letsencrypt.org/).

The reason we can't turn this on by default like many of the other ansible
roles in this repository is that it requires client-specific variables.
HTTPS is established by having a certificate authority (in our case, that
certificate authority is called LetsEncrypt) validate that a webserver owns
a domain, so you need to specify the domain name you host galaxy at in order
for us to ask LetsEncrypt to verify that you own it and issue you a certificate.

### Use

First, you need to set `{{ galaxy_extras_config_letsencrypt }}` to `True` which
you can do by calling this ansible role with `--extra-vars galaxy_extras_config_letsencrypt=True`

Then, you need to make sure the `startup.sh` script has access to an environment
variable called `GALAXY_CONFIG_DOMAIN` which is set to the domain name you would like to certify.

If you're using [Docker-Galaxy-Stable](https://github.com/bgruening/docker-galaxy-stable/) or some
derivative image, you can specify `GALAXY_CONFIG_DOMAIN` at runtime by running the image
with a command like

```docker run -d -p 80:80 -p 443:443 -e "GALAXY_CONFIG_DOMAIN=yourdomain.edu" your_image```

