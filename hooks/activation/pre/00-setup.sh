#!/usr/bin/env bash

cd "${0%/*}"

randpw(){ < /dev/urandom tr -dc "[:alpha:]" | head -c1; < /dev/urandom tr -dc "_[:alnum:]" | head -c${1:-15};echo;}

echo "export EK_DATA_PWD=$(randpw)" > tmp/config
echo "export EK_META_PWD=$(randpw)" >> tmp/config
echo "export EK_WORK_PWD=$(randpw)" >> tmp/config

LAST_USER_NUM=$(cat etc/last-user-num)
NEXT_USER_NUM=$(($LAST_USER_NUM + 1))
echo "export EK_USER_NUM=$(cat etc/last-user-num)" >> tmp/config
echo $NEXT_USER_NUM > etc/last-user-num


