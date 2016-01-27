#!/usr/bin/env bash

cd "${0%/*}"

. etc/config.sh

EK_USERNAME="$1"

DS_CONTENTS=$(cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<datasources xmlns="http://www.jboss.org/ironjacamar/schema">
    <datasource jta="false" jndi-name="java:/I2B2_17_PRJ${NEXT_USER_NUM}_DATA_DS"
                pool-name="I2B2_17_PRJ${NEXT_USER_NUM}_DATA_DS" enabled="true" use-ccm="false">
        <connection-url>jdbc:oracle:thin:@eurekadb.cci.emory.edu:1521:CVRGDEV</connection-url>
        <driver-class>oracle.jdbc.OracleDriver</driver-class>
        <driver>ojdbc6.jar</driver>
        <security>
            <user-name>I2B2_17_PRJ_${NEXT_USER_NUM}_DATA</user-name>
            <password>${EK_DATA_PWD}</password>
        </security>
        <validation>
            <validate-on-match>false</validate-on-match>
            <background-validation>false</background-validation>
        </validation>
        <statement>
            <share-prepared-statements>false</share-prepared-statements>
        </statement>
    </datasource>
    <datasource jta="false" jndi-name="java:/I2B2_17_PRJ${NEXT_USER_NUM}_METADATA_DS"
                pool-name="I2B2_17_PRJ${NEXT_USER_NUM}_METADATA_DS" enabled="true" use-ccm="false">
        <connection-url>jdbc:oracle:thin:@eurekadb.cci.emory.edu:1521:CVRGDEV</connection-url>
        <driver-class>oracle.jdbc.OracleDriver</driver-class>
        <driver>ojdbc6.jar</driver>
        <security>
            <user-name>I2B2_17_PRJ_${NEXT_USER_NUM}_METADATA</user-name>
            <password>${EK_META_PWD}</password>
        </security>
        <validation>
            <validate-on-match>false</validate-on-match>
            <background-validation>false</background-validation>
        </validation>
        <statement>
            <share-prepared-statements>false</share-prepared-statements>
        </statement>
    </datasource>
    <datasource jta="false" jndi-name="java:/I2B2_17_PRJ${NEXT_USER_NUM}_IMDATA_DS"
                pool-name="I2B2_17_PRJ${NEXT_USER_NUM}_IMDATA_DS" enabled="true" use-ccm="false">
        <connection-url>jdbc:oracle:thin:@eurekadb.cci.emory.edu:1521:CVRGDEV</connection-url>
        <driver-class>oracle.jdbc.OracleDriver</driver-class>
        <driver>ojdbc6.jar</driver>
        <security>
            <user-name>I2B2_17_PRJ_${NEXT_USER_NUM}_IMDATA</user-name>
            <password>${EK_IM_PWD}</password>
        </security>
        <validation>
            <validate-on-match>false</validate-on-match>
            <background-validation>false</background-validation>
        </validation>
        <statement>
            <share-prepared-statements>false</share-prepared-statements>
        </statement>
    </datasource>
    <datasource jta="false" jndi-name="java:/I2B2_17_PRJ${NEXT_USER_NUM}_WORKDATA_DS"
                pool-name="I2B2_17_PRJ${NEXT_USER_NUM}_WORKDATA_DS" enabled="true" use-ccm="false">
        <connection-url>jdbc:oracle:thin:@eurekadb.cci.emory.edu:1521:CVRGDEV</connection-url>
        <driver-class>oracle.jdbc.OracleDriver</driver-class>
        <driver>ojdbc6.jar</driver>
        <security>
            <user-name>I2B2_17_PRJ_${NEXT_USER_NUM}_WORKDATA</user-name>
            <password>${EK_WORK_PWD}</password>
        </security>
        <validation>
            <validate-on-match>false</validate-on-match>
            <background-validation>false</background-validation>
        </validation>
        <statement>
            <share-prepared-statements>false</share-prepared-statements>
        </statement>
    </datasource>
</datasources>
EOF
)

echo "$DS_CONTENTS" > "$JBOSS_HOME/standalone/deployments/I2B2_17_PRJ${NEXT_USER_NUM}-ds.xml"
