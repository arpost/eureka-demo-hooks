#!/usr/bin/env bash

cd "${0%/*}"

. etc/config.sh

# PM TABLES

ORACLE_USER="$I2B2_PM_USER"
ORACLE_PASS="$I2B2_PM_PWD"

PM_USER_DATA_STMT=$(cat <<EOF
INSERT INTO PM_USER_DATA 
(
USER_ID,
FULL_NAME,
PASSWORD,
EMAIL,
CHANGE_DATE,
ENTRY_DATE,
CHANGEBY_CHAR,
STATUS_CD
) values (
'${1}',
'${2}',
'${3}',
'undefined',
sysdate,
sysdate,
'Eureka admin',
'A');
EOF
)
ek_execute_sql "$PM_USER_DATA_STMT"

PM_PROJECT_DATA_STMT=$(cat <<EOF
INSERT INTO PM_PROJECT_DATA 
(
PROJECT_ID,
PROJECT_NAME,
PROJECT_WIKI,
PROJECT_KEY,
PROJECT_PATH,
PROJECT_DESCRIPTION,
CHANGE_DATE,
ENTRY_DATE,
CHANGEBY_CHAR,
STATUS_CD
) values (
'EurekaProject${NEXT_USER_NUM}',
'EurekaProject${NEXT_USER_NUM}',
'EurekaProject${NEXT_USER_NUM}',
null,
'/EurekaProject${NEXT_USER_NUM}',
'EurekaProject${NEXT_USER_NUM}',
sysdate,
sysdate,
'Eureka admin',
'A'
)
EOF
)
ek_execute_sql "$PM_PROJECT_DATA_STMT"

USER_ROLES=( 'DATA_AGG' 'DATA_DEID' 'DATA_LDS' 'DATA_OBFSC' 'DATA_PROT' 'USER' )

for i in "${USER_ROLES[@]}"
do
PM_PROJECT_USER_ROLE_STMT=$(cat <<EOF
  ek_execute_sql "INSERT INTO PM_PROJECT_USER_ROLES (PROJECT_ID,USER_ID,USER_ROLE_CD,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD) VALUES ('EurekaProject${NEXT_USER_NUM}','${1}','${i}',sysdate,sysdate,'Eureka admin','A')"
EOF
)
  ek_execute_sql "$PM_PROJECT_USER_ROLE_STMT"
done

ek_execute_sql "Insert into PM_PROJECT_USER_ROLES (PROJECT_ID,USER_ID,USER_ROLE_CD,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD) values ('EurekaProject${NEXT_USER_NUM}','OBFSC_SERVICE_ACCOUNT','DATA_OBFSC',sysdate,sysdate,'Eureka admin','A')"
ek_execute_sql "Insert into PM_PROJECT_USER_ROLES (PROJECT_ID,USER_ID,USER_ROLE_CD,CHANGE_DATE,ENTRY_DATE,CHANGEBY_CHAR,STATUS_CD) values ('EurekaProject${NEXT_USER_NUM}','OBFSC_SERVICE_ACCOUNT','USER',sysdate,sysdate,'Eureka admin','A')"

# METADATA TABLES

ORACLE_USER="I2B2_17_PRJ_${NEXT_USER_NUM}_METADATA"
ORACLE_PASS="${EK_META_PWD}"

DDL=$(cat <<EOF
create table EUREKA 
( 
c_hlevel decimal(22) not null, 
c_fullname varchar2(700) not null, 
c_name varchar2(2000) not null, 
c_synonym_cd char(1) not null,
c_visualattributes char(3) not null, 
c_totalnum decimal(22), 
c_basecode varchar2(50), 
c_metadataxml clob, 
c_facttablecolumn varchar2(50) not null, 
c_tablename varchar2(50) not null,
c_columnname varchar2(50) not null, 
c_columndatatype varchar2(50) not null, 
c_operator varchar2(10) not null, 
c_dimcode varchar2(700) not null, 
c_comment clob, 
c_tooltip varchar2(900),
update_date timestamp not null, 
download_date timestamp, 
import_date timestamp, 
sourcesystem_cd varchar2(50), 
valuetype_cd varchar2(50)
);
EOF
)

ek_execute_sql "$DDL"

ek_execute_sql "DELETE FROM TABLE_ACCESS"

INSERT_STMT=$(cat <<EOF
INSERT INTO TABLE_ACCESS
(
C_TABLE_CD,
C_TABLE_NAME,
C_PROTECTED_ACCESS,
C_HLEVEL,
C_FULLNAME,
C_NAME,
C_SYNONYM_CD,
C_VISUALATTRIBUTES,
C_TOTALNUM,
C_BASECODE,
C_FACTTABLECOLUMN,
C_DIMTABLENAME,
C_COLUMNNAME,
C_COLUMNDATATYPE,
C_OPERATOR,
C_DIMCODE,
C_TOOLTIP,
C_ENTRY_DATE,
C_CHANGE_DATE,
C_STATUS_CD,
VALUETYPE_CD
) 
values 
(
'EUREKA',
'EUREKA',
'N',
0,
'\Eureka\',
'Eureka',
'N',
'CA ',
null,
null,
'concept_cd',
'concept_dimension',
'concept_path',
'T',
'LIKE',
'\Eureka\',
'Eureka',
null,
null,
null,
null)
EOF
)

ek_execute_sql "$INSERT_STMT"

