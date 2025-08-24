This is a project to deploy an Oracle Database and Listener in docker container using Jenkins and Validate the DB status.

+--------------------------------------------------+
|              Jenkins Pipeline                    |
+--------------------------------------------------+
        |
        v
+-------------------------------+
| Stage 1: Check Conflicts      |
| - Look for container name     |
|   ${ORACLE_CNAME}             |
| - Stop & Remove if exists     |
+-------------------------------+
        |
        v
+-------------------------------+
| Stage 2: Pull Oracle Image    |
| - Check if ${ORACLE_IMAGE}    |
|   is present locally          |
| - If not, docker pull         |
| - Else, use local image       |
+-------------------------------+
        |
        v
+-------------------------------+
| Stage 3: Initiate Container   |
| - docker run with:            |
|   - Name: ${ORACLE_CNAME}     |
|   - Port: ${ORACLE_PORT}      |
|   - Password: ${ORACLE_PASS}  |
+-------------------------------+
        |
        v
+-------------------------------+
| Stage 4: Validate Oracle DB   |
| - Retry up to MAX_RETRIES     |
| - Wait for container RUNNING  |
| - Copy validate_db.sql inside |
| - Run sqlplus validation      |
| - Check for "OPEN" state      |
+-------------------------------+
        |
        v
+-------------------------------+
| Stage 5: Validate DB Status   |
| - Copy db-ls-status.sql       |
| - Run sqlplus on it           |
| - Run lsnrctl status          |
+-------------------------------+
        |
        v
+-------------------------------+
|   Post Actions (Always Run)   |
| - docker stop ${ORACLE_CNAME} |
| - docker rm   ${ORACLE_CNAME} |
| - (Optional cleanWs)          |
+-------------------------------+
