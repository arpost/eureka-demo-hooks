#!/usr/bin/env bash

cd "${0%/*}"

. etc/config.sh

ORACLE_USER="I2B2_17_PRJ_${NEXT_USER_NUM}_METADATA"
ORACLE_PASS="${EK_META_PWD}"

SQL=$(cat <<EOF
create table cardiovascularregistry 
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

ek_execute_sql "$SQL"

