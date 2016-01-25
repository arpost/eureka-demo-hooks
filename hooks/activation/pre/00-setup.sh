#!/usr/bin/env bash

cd "${0%/*}"

. etc/config.sh

if [ ! -d tmp ] ; then
    mkdir tmp
fi

DYNAMIC_CONFIG_FILE=tmp/config

randpw(){ < /dev/urandom LC_CTYPE=C tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}

echo EK_DATA_PWD="$(randpw)" > $DYNAMIC_CONFIG_FILE
echo EK_META_PWD="$(randpw)" >> $DYNAMIC_CONFIG_FILE
echo EK_WORK_PWD="$(randpw)" >> $DYNAMIC_CONFIG_FILE
echo EK_IM_PWD="$(randpw)" >> $DYNAMIC_CONFIG_FILE

LAST_USER_NUM=$(cat etc/last-user-num)
NEXT_USER_NUM=$(($LAST_USER_NUM + 1))
echo "export EK_USER_NUM=$(cat etc/last-user-num)" >> $DYNAMIC_CONFIG_FILE
echo $NEXT_USER_NUM > etc/last-user-num
echo NEXT_USER_NUM="$NEXT_USER_NUM" >> $DYNAMIC_CONFIG_FILE

ORACLE_USER="${EK_BACKEND_USER}"
ORACLE_PSWD="${EK_BACKEND_PWD}"

INSERT_STMT=$(cat <<EOF
INSERT INTO USERS VALUES (USER_SEQ.NEXTVAL, '$1');
COMMIT;
EOF
)

ek_execute_sql "$INSERT_STMT"
