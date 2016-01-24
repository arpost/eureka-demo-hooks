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
