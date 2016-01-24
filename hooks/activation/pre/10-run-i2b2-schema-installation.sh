#!/usr/bin/env bash

WORKING_DIR="${0%/*}"

cd "$WORKING_DIR"

. "$WORKING_DIR"/tmp/config

cd "$WORKING_DIR/i2b2"

# creating tables for next user

#Workdata
sudo sh -c "sed 's/^db.username.*/db.username=user_$(echo $EK_USER_NUM)_workdata/g' Workdata/db.properties >Workdata/dbtemp.properties"
sudo sh -c "sed 's/^db.password.*/db.password=$(echo $EK_WORK_PWD)/g' Workdata/dbtemp.properties >Workdata/db.properties"
ant -f Workdata/data_build.xml create_workdata_tables_release_1-5
ant -f Workdata/data_build.xml db_workdata_load_data

#demodata
sudo sh -c "sed 's/^db.username.*/db.username=user_$(echo $EK_USER_NUM)_data/g' Demodata/db.properties >Demodata/dbtemp.properties"
sudo sh -c "sed 's/^db.password.*/db.password=$(echo $EK_DATA_PWD)/g' Demodata/dbtemp.properties >Demodata/db.properties"
ant -f Demodata/data_build.xml create_demodata_tables_release_1-5
ant -f Demodata/data_build.xml create_procedures_release_1-5


#Metadata
sudo sh -c "sed 's/^db.username.*/db.username=user_$(echo $EK_USER_NUM)_metadata/g' Metadata/db.properties >Metadata/dbtemp.properties"
sudo sh -c "sed 's/^db.password.*/db.password=$(echo $EK_META_PWD)/g' Metadata/dbtemp.properties >Metadata/db.properties"
ant -f Metadata/data_build.xml create_metadata_tables_release_1-5
ant -f Metadata/cvrg_data_build.xml create_cvrg_tables_release_1-5
ant -f Metadata/cvrg_data_build.xml db_cvrg_load_data
