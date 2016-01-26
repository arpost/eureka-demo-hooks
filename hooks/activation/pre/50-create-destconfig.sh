#!/usr/bin/env bash

cd "${0%/*}"

. etc/config.sh

EK_USERNAME="$1"
DEST_CONFIG_FILENAME="config${NEXT_USER_NUM}.xml"

DEST_CONTENTS=$(cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Configures the i2b2 query results handler. -->
<queryResultsHandler>
    <type>I2B2</type>
    <displayName>I2B2</displayName>
    <!-- A dictionary of properties for configuring the i2b2 query results
         handler.
    -->
    <dictionary>
	<entry key="projectName"          value="I2B2_17_PRJ${NEXT_USER_NUM}"/>
        <!-- The name of the metadata table for this project as specified in
             the project's i2b2 project manager configuration. 
        -->
        <entry key="metaTableName"         value="EUREKA"/>
        <!-- The name of the root concept in the term browser. Must be the same
             as the concept name specified in the i2b2 project manager 
             configuration.
        -->
        <entry key="rootNodeName"          value="Eureka"/>
        <!-- Whether to truncate the data and metadata tables before loading.
             May be true or false.
        -->
        <entry key="truncateTables"        value="true"/>
        <!-- The proposition id representing a visit. -->
        <entry key="visitDimension" value="Encounter"/>
        <!-- The property of a visit proposition to use as an encounter id.
        -->
        <entry key="visitDimensionDecipheredId" value="visit_id"/>
        <!-- The dataType (see the data section below) specifying how to access
             a provider's full name.
        -->
        <entry key="providerFullName" value="providerFullName"/>
        <!-- The dataType (see the data section below) specifying how to access
             a provider's first name.
        -->
        <entry key="providerFirstName" value="providerFirstName"/>
        <!-- The dataType (see the data section below) specifying how to access
             a provider's middle name.
        -->
        <entry key="providerMiddleName" value="providerMiddleName"/>
        <!-- The dataType (see the data section below) specifying how to access
             a provider's last name.
        -->
        <entry key="providerLastName" value="providerLastName"/>
        <!-- The dataType (see the data section below) specifying how to access
             a patient's medical record number.
        -->
        <entry key="patientDimensionMRN" value="demographics_mrn"/>
        <!-- The dataType (see the data section below) specifying how to access
             a patient's gender.
        -->
        <entry key="patientDimensionGender" value="demographics_gender"/>
        <!-- The concept code prefix to use for representing patient ages.
        -->
        <entry key="ageConceptCodePrefix" value="DEM|AGE"/>
        <!-- The dataType (see the data section below) specifying how to access
             a patient's ethnicity.
        -->
        <entry key="patientDimensionEthnicity" value="demographics_ethnicity"/>
        <!-- The dataType (see the data section below) specifying how to access
             a patient's race.
        -->
        <entry key="patientDimensionRace" value="demographics_race"/>
        <!-- The dataType (see the data section below) specifying how to access
             a patient's marital status.
        -->
        <entry key="patientDimensionMaritalStatus" value="demographics_marital_status" />
        <!-- The dataType (see the data section below) specifying how to access
             a patient's language.
        -->
        <entry key="patientDimensionLanguage" value="demographics_lang" />
        <!-- The dataType (see the data section below) specifying how to access
             a patient's religion.
        -->
        <entry key="patientDimensionReligion" value="demographics_religion" />
        <!-- The dataType (see the data section below) specifying how to access
             a patient's date of birth.
        -->
        <entry key="patientDimensionBirthdate" value="demographics_dob" />
    </dictionary>

    <!-- JDBC database connection information for the data schema and the 
         metadata schema. Each of the two schema (dbschema) tags has the 
         following attributes:
            key = dataschema or metaschema.
            connect = a JDBC URL.
            user = database user name.
            passwd = database password.
    -->
    <database>
        <dbschema key="dataschema" connect="jdbc:oracle:thin:@eurekadb.cci.emory.edu:1521/CVRGDEV" user="I2B2_17_PRJ_${NEXT_USER_NUM}_DATA" passwd="${EK_DATA_PWD}"/>
        <dbschema key="metaschema" connect="jdbc:oracle:thin:@eurekadb.cci.emory.edu:1521/CVRGDEV" user="I2B2_17_PRJ_${NEXT_USER_NUM}_METADATA" passwd="${EK_META_PWD}"/>
    </database>

    <!-- Specifies the data to load into the observation_fact table. Different
         kinds of data are specified each in a dataType tag with the following 
         attributes:
            key = an unique name for this data type.
            reference = the name of a reference from the proposition definition
                specified above in the visitDimension dictionary entry. The
                data referred-to by the reference will be loaded.
            property = the value set of the specified property will be loaded
                as facts (optional).
            start = for value set elements, specifies whether to use the start 
                or the finish of the proposition as its timestamp. Allowed
                values are "start" and "finish".
            conceptCodePrefix = specifies a concept code prefix for all facts
                specified by this data type entry (optional).
    -->
    <data>
        <!-- Specifies that propositions referred-to by a visit proposition's
             diagnosisCodes reference should be loaded.
        -->
        <dataType key="diagnoses" reference="diagnosisCodes"/>
        <dataType key="meds" reference="medicationHistory"/>
        <dataType key="labs" reference="labs" units="unitOfMeasure" />
        <dataType key="procedures" reference="procedures"/>
        <dataType key="vital" reference="vitals"/>
        <!-- Specifies that the value of every visit proposition's 
             dischargeDisposition property should be loaded.
        -->
        <dataType key="dschgDisp" property="dischargeDisposition" start="finish" />
        <dataType key="providerFullName" reference="provider" property="fullName" />
        <dataType key="providerFirstName" reference="provider" property="firstName" />
        <dataType key="providerMiddleName" reference="provider" property="middleName" />
        <dataType key="providerLastName" reference="provider" property="lastName" />
        <!-- Specifies that the value of the gender property of all 
             propositions referred-to by every visit proposition's 
             patientDetails reference should be loaded. Those facts should use 
             the corresponding visit proposition's start time as their 
             timestamp, and their concept codes will be created as 
             'DEM|SEX:<value>'.
        -->
        <dataType key="demographics_gender" reference="patientDetails" property="gender" start="start" conceptCodePrefix='DEM|SEX'/>
        <dataType key="demographics_ethnicity" reference="patientDetails" property="ethnicity"  start="start"/>
        <dataType key="demographics_race" reference="patientDetails" property="race" conceptCodePrefix="DEM|RACE" start="start"/>
        <dataType key="demographics_marital_status" reference="patientDetails" property="maritalStatus" conceptCodePrefix="DEM|MARITAL" start="start"/>
        <dataType key="demographics_lang" reference="patientDetails" property="language" conceptCodePrefix="DEM|LANGUAGE" start="start" />
        <dataType key="demographics_religion" reference="patientDetails" property="religion" start="start"/>
        <dataType key="demographics_mrn" reference="patientDetails" property="patientId"/>
        <dataType key="demographics_dob" reference="patientDetails" property="dateOfBirth"/>
        <dataType key="visit_id" property="encounterId"/>
    </data>

    <!-- Specifies the folders to display in the i2b2 term browser.
         
         Attributes:
            displayName = what shows up in the UI
            skipGen = skips n levels of the inverseIsA hierarchy in the AIW
                ontology.
            proposition = the id of the proposition definition representing a 
                subtree of the AIW ontology to display (unless the property 
                attribute is specified, see below).
            property = the name of a property of the proposition definition
                specified above. Causes the property's value set to be 
                displayed in the folder.
            valueType = LABORATORY_TESTS or TEXT, if the concepts in the
                folder represent either kind of data.

         Note: The folder order matters! I2b2 does not permit a concept
         to have multiple parents, but the AIW ontologies do have propositions
         with multiple parents. We work around this the following way: for 
         concepts that are a parent of a child with another parent specified in 
         an earlier folder, we make the concept appear in that folder as a 
         leaf. To use this to best effect, we recommend that standard code 
         hierarchies be listed first and that those hierarchies not implement 
         multiple inheritance or refer to each other's concepts in any way 
         (what you should normally do with i2b2). Subsequently, list folders 
         for your custom concepts, which may include parents of concepts from
         the standard code hierarchies or from an earlier custom concept 
         folder. For custom concepts that are a parent of a concept in an
         earlier folder, such variables will appear as leaves in the browser.
    -->
    <concepts>
        <!-- Creates a folder in the term browser named "CPT Codes". Its
             contents will be the "CPTCode" subtree of the AIW ontology, 
             starting at the second level of the subtree.
        -->
        <folder displayName="CPT Codes"             skipGen="1" proposition="CPTCode"/>
        <folder displayName="ICD9 Diagnostic Codes" skipGen="1" proposition="ICD9:Diagnoses"/>
        <folder displayName="ICD9 Procedure Codes"  skipGen="1" proposition="ICD9:Procedures"/>
        <folder displayName="Laboratory Tests"      skipGen="1" proposition="LAB:LabTest" valueType="LABORATORY_TESTS" />
        <!-- Creates a folder in the term browser named 
             "Discharge Disposition". Its contents will be the allowed values
             of the dischargeDisposition property of the ENcounter proposition
             definition.
        -->
        <folder displayName="Discharge Disposition" skipGen="1" proposition="Encounter" property="dischargeDisposition"/>
        <folder displayName="Medication"            skipGen="2" proposition="MED:medications"/>
        <folder displayName="Vital Signs"           skipGen="1" proposition="VitalSign"/>
        <folder displayName="Hospital Readmissions" skipGen="0" proposition="READMISSIONS:EncounterWithSubsequent30DayReadmission"/>
        <folder displayName="Hospital Readmissions" skipGen="0" proposition="READMISSIONS:SecondReadmit"/>
        <folder displayName="Hospital Readmissions" skipGen="0" proposition="READMISSIONS:FrequentFlierEncounter"/>
        <folder displayName="Hospital Readmissions" skipGen="0" proposition="READMISSIONS:Chemotherapy180DaysBeforeSurgery"/>
        <folder displayName="Hospital Readmissions" skipGen="0" proposition="READMISSIONS:Chemotherapy365DaysBeforeSurgery"/>
        <folder displayName="Hospital Readmissions" skipGen="0" proposition="READMISSIONS:Encounter90DaysEarlier"/>
        <folder displayName="Hospital Readmissions" skipGen="0" proposition="READMISSIONS:Encounter180DaysEarlier"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:MyocardialInfarction"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="READMISSIONS:SecondMI"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:UncontrolledDiabetes"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:EndStageRenalDisease"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:Obesity"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="ERATCancer"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="ERATCKD"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="ERATCOPD"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="ERATDiabetes"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="ERATHF"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="ERATHxTransplant"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="ERATPulmHyp"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="ERATStroke"/>
        <!--
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:MethicillinResistantStaphAureusEvent"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:SickleCellAnemiaEvent"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:SickleCellCrisisEvent"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:ThrombocytopeniaEvent"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:MetastasisEvent"/>
        <folder displayName="Comorbidities" skipGen="0" proposition="DISEASEINDICATOR:HypertensionEvent"/>
        -->
    </concepts>
</queryResultsHandler>
EOF
)

echo $DEST_CONTENTS > "${EK_DESTCONFIG_DIR}/${DEST_CONFIG_FILENAME}"

ORACLE_USER="${EK_BACKEND_USER}"
ORACLE_PASS="${EK_BACKEND_PWD}"

ek_execute_sql "INSERT INTO DESTINATIONS VALUES (DEST_SEQ.NEXTVAL, '$DEST_CONFIG_FILENAME', (SELECT ID FROM USERS WHERE USERNAME='${1}'))"

