SELECT name, status, open_mode FROM v$instance;
SELECT * FROM dba_data_files GROUP BY tablespace_name;
SELECT * FROM v$version;
EXIT;