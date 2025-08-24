SELECT name, status, open_mode FROM v$instance;
SELECT tablespace_name, round(SUM(bytes)/1024/1024,2) AS size_mb FROM dba_data_files GROUP BY tablespace_name;
SELECT * FROM v$version;
EXIT;