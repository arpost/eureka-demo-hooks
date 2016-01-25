#!/usr/bin/env bash

cd "${0%/*}"

. etc/config.sh

EK_USERNAME=${1//[.@]/_}

SC_CONTENTS=$(cat <<EOF
[edu.emory.cci.aiw.cvrg.eureka.etl.dsb.EurekaDataSourceBackend]
dataSourceBackendId=AIW
databaseName = $EK_USERNAME
dataFileDirectoryName = $EK_USERNAME
mimetypes = application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
sampleUrl = ../docs/sample.xlsx
required = true

[org.protempa.backend.ksb.protege.LocalKnowledgeSourceBackend]
knowledgeBaseName = AIW
projectString = /etc/eureka/ontologies/AIW.pprj
units = ABSOLUTE

[org.protempa.backend.asb.java.JavaAlgorithmBackend]
EOF
)

#echo $SC_CONTENTS > "$EK_SOURCECONFIG_DIR"/"$EK_USERNAME"


ORACLE_USER="${EK_BACKEND_USER}"
ORACLE_PSWD="${EK_BACKEND_PWD}"

SQL=$(cat <<EOF
INSERT INTO SOURCECONFIGS VALUES (SOURCECONFIG_SEQ.NEXTVAL, '${1}', (SELECT ID FROM USERS WHERE USERNAME='${1}'));
COMMIT;
EOF
)
ek_execute_sql "$SQL"
