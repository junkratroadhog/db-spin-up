set lines 1000;
set pages 1000;
SELECT instance_name, status, database_status, version FROM v$instance;
SELECT TABLESPACE_NAME, STATUS, FILE_NAME, ONLINE_STATUS FROM dba_data_files;
SELECT BANNER_FULL,BANNER_LEGACY FROM v$version;
EXIT;