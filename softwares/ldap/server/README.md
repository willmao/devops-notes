# OpenLDAP

Openldap docker deploy with HA.

## Get Started

We need two nodes to deploy OpenLDAP HA cluster:

- build docker image
- copy docker-compose related files to node 1 and 2
- change docker-compose and OpenLDAP config file openldap/sldapd.ldif properly, node 1 and 2 replica from each other
- start OpenLDAP with docker-compose on node 1 and 2
- login docker container and run ldap scripts to init dc Object
- recommend to set up haproxy to proxy request to first active node when possible, haproxy supports first balance algorithm and ldap health check

## Permissions

- config db has the largest permission and should only be accessed on localhost

