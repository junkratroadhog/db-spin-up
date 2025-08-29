docker cp scripts/deploy/db-health-check.sql ${ORACLE_CNAME}:/tmp/db-health-check.sql
docker exec -i ${ORACLE_CNAME} sqlplus -s / as sysdba @/tmp/db-health-check.sql
docker exec -i ${ORACLE_CNAME} lsnrctl status