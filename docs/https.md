# HTTPS using ansible-galaxy-extras

### Introduction

There are three ways in which you can configure nginx for HTTPS using this role.
 - Using your own keys
 - Using self-signed keys
 - Using [letsencrypt](https://letsencrypt.org/)

### Use

For all methods, set `galaxy_extras_config_ssl` to `True` and set
`galaxy_extras_config_ssl_method` to 'own', 'self-signed' or 
'letsencrypt', depending on which method you would like to use.

If you are using your own keys, point `src_nginx_ssl_certificate_key`
and `src_nginx_ssl_certificate` to the path on the control machine where
the keys are stored. They will be copied onto the target host.

If you are using letsencrypt, set galaxy_extras_galaxy_domain to the 
domain that nginx will be reachable under.

No additional action needs to be taken if using self-signed keys.