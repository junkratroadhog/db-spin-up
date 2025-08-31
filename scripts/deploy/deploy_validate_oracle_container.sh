#!/bin/bash
set -e

MAX_INTERVAL=20
MAX_RETRIES=10
SUCCESS=0

for i in $(seq 1 $MAX_RETRIES); do
    echo "Waiting for Oracle DB to start... ($i/$MAX_RETRIES)"
    sleep $MAX_INTERVAL
    RUNNING=$(docker inspect -f '{{.State.Running}}' ${ORACLE_CNAME})
    if [ "$RUNNING" != "true" ]; then
        echo "Oracle container is not running!"
        docker logs ${ORACLE_CNAME}
        exit 1
    fi

    if [ $i -le $MAX_RETRIES ]; then
        docker cp scripts/deploy/db-validate.sql ${ORACLE_CNAME}:/tmp/db-validate.sql
        OUTPUT=$(docker exec -i ${ORACLE_CNAME} sqlplus -s / as sysdba @/tmp/db-validate.sql)
    fi

    if echo "$OUTPUT" | grep -q "OPEN"; then
        echo "✅ Oracle DB is ready!"
        SUCCESS=1
        break
    fi
done

if [ $SUCCESS -ne 1 ]; then
    echo "Oracle DB failed to start within expected time."
    docker logs ${ORACLE_CNAME}
    exit 1
fi

echo "Oracle Container ${ORACLE_CNAME} started successfully."