SELECT instance_name, status, database_status, version FROM v$instance;
SELECT name FROM dba_data_files;
SELECT BANNER_FULL,BANNER_LEGACY FROM v$version;
EXIT;