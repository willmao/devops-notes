#!/bin/bash

set -e

OPENLDAP_BASE_DIR=/usr/local/openldap
OPENLDAP_CONF_DIR=${OPENLDAP_BASE_DIR}/slapd.d
OPENLDAP_DB_BASE_DIR=${OPENLDAP_BASE_DIR}/dbs
# databases to init
OPENLDAP_DB_NAMES=(
  example
)
OPENLDAP_LOG_LEVEL=${OPENLDAP_LOG_LEVEL:-0}
OPENLDAP_USER_NAME=ldap
OPENLDAP_USER_GROUP=ldap
OPENLDAP_SERVE_URLS=${OPENLDAP_SERVE_URLS:-"ldap:/// ldaps:///"}

echo "check root folder"
if [[ ! -d ${OPENLDAP_BASE_DIR} ]]; then
  echo "oepnldap root folder doest not exist, please mount it into docker container"
  exit -1
fi

if [[ ! -d ${OPENLDAP_CONF_DIR} ]]; then
  echo "openldap config folder does not exist, auto create it"
  mkdir -p ${OPENLDAP_CONF_DIR}
fi

if [[ ! -d ${OPENLDAP_DB_BASE_DIR} ]]; then
  echo "openldap database base folder does not exist, auto create it"
  mkdir -p ${OPENLDAP_DB_BASE_DIR}
fi

for db in "${OPENLDAP_DB_NAMES[@]}"; do
  db_path=${OPENLDAP_DB_BASE_DIR}/${db}
  if [[ ! -d ${db_path} ]]; then
    echo "openldap database ${db} path does not exist，auto create it"
    mkdir -p ${db_path}
  fi
done

cd ${OPENLDAP_BASE_DIR}

if [[ -z "$(ls -A ${OPENLDAP_CONF_DIR})" ]]; then
  echo "init openldap config"
  slapadd -d any -n 0 -F ./slapd.d -l ./slapd.ldif
else
  echo "openldap config already exist"
fi

echo "fix openldap folder permission"
chown -R ${OPENLDAP_USER_NAME}:${OPENLDAP_USER_GROUP} ${OPENLDAP_BASE_DIR}

echo "start openldap slapd service with user ${OPENLDAP_USER_NAME}"
exec slapd -F ${OPENLDAP_CONF_DIR} -u ${OPENLDAP_USER_NAME} -g ${OPENLDAP_USER_GROUP} -d ${OPENLDAP_LOG_LEVEL} -h "${OPENLDAP_SERVE_URLS}"
