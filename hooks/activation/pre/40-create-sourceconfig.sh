#!/usr/bin/env bash

cd "${0%/*}"

SC_CONTENTS << EOF
[edu.emory.cci.aiw.cvrg.eureka.etl.dsb.EurekaDataSourceBackend]
dataSourceBackendId=AIW
databaseName = mark_braunstein_cc_gatech_edu
dataFileDirectoryName = mark_braunstein_cc_gatech_edu
mimetypes = application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
sampleUrl = ../docs/sample.xlsx
required = true

[org.protempa.backend.ksb.protege.LocalKnowledgeSourceBackend]
knowledgeBaseName = AIW
projectString = /etc/eureka/ontologies/AIW.pprj
units = ABSOLUTE

[org.protempa.backend.asb.java.JavaAlgorithmBackend]
EOF

echo $SC_CONTENTS > "$EK_SOURCECONFIG_DIR"/"$EK_USERNAME"

