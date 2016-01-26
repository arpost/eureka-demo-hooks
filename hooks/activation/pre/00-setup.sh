#!/usr/bin/env bash

cd "${0%/*}"

if [ ! -f tmp ] ; then
    mkdir tmp
fi

DYNAMIC_CONFIG_FILE=tmp/config

randpw(){ < /dev/urandom tr -dc "[:alpha:]" | head -c1; < /dev/urandom tr -dc "_[:alnum:]" | head -c${1:-15};echo;}

echo EK_DATA_PWD="$(randpw)" > $DYNAMIC_CONFIG_FILE
echo EK_META_PWD="$(randpw)" >> $DYNAMIC_CONFIG_FILE
echo EK_WORK_PWD="$(randpw)" >> $DYNAMIC_CONFIG_FILE
echo EK_IM_PWD="$(randpw)" >> $DYNAMIC_CONFIG_FILE

LAST_USER_NUM=$(cat etc/last-user-num)
NEXT_USER_NUM=$(($LAST_USER_NUM + 1))
echo "export EK_USER_NUM=$(cat etc/last-user-num)" >> $DYNAMIC_CONFIG_FILE
echo $NEXT_USER_NUM > etc/last-user-num

ORACLE_USER="${EK_BACKEND_USER}"
ORACLE_PASS="${EK_BACKEND_PWD}"

ek_execute_sql "INSERT INTO USERS VALUES ()"
