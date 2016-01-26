#!/usr/bin/env bash

cd "${0%/*}"

. etc/config.sh

EK_USERNAME="$1"

ORACLE_USER="${EK_BACKEND_USER}"
ORACLE_PASS="${EK_BACKEND_PWD}"


ek_execute_sql "INSERT INTO I2B2_DESTINATIONS VALUES ()"
