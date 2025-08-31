#!/bin/bash
set -e

echo "Cleaning up..."
if [ "${RETAIN_DB}" != "true" ]; then
    docker stop ${ORACLE_CNAME}
    docker rm ${ORACLE_CNAME}
    docker volume rm oradata_${ORACLE_SID}

else
    echo "Retaining Oracle DB container ${ORACLE_CNAME}..."
    docker stop ${ORACLE_CNAME}
fi