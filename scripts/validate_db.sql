SET HEADING OFF;
SET FEEDBACK OFF;
SELECT instance_name, status, open_mode FROM v$instance;
SELECT name, open_mode FROM v$database;
EXIT;