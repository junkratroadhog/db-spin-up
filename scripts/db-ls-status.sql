set lines 1000;
set pages 1000;
col FILE_NAME for a60;
SELECT instance_name, STATUS, database_status, version FROM v$instance;
SELECT TABLESPACE_NAME, ONLINE_STATUS, FILE_NAME FROM dba_data_files;
SELECT BANNER_FULL,BANNER_LEGACY FROM v$version;
EXIT;