#!/bin/bash
set -e

if [ $(docker ps -a -q -f name=${ORACLE_CNAME}) ]; then
    echo "Container ${ORACLE_CNAME} already exists. Starting it..."
    docker start ${ORACLE_CNAME}
    echo "Container ${ORACLE_CNAME} started successfully."
else
    if [ -z "$(docker images -q ${ORACLE_IMAGE})" ]; then
        echo "Docker Image not found. Pulling..."
        docker pull ${ORACLE_IMAGE}
    else
        echo "Local Docker Image is available."
    fi

    sh """
        echo "Creating Docker container ${env.ORACLE_CNAME} from image ${env.ORACLE_IMAGE}..."
        echo "ORACLE_SID=${env.ORACLE_SID}"
        echo "ORACLE_PDB=${env.ORACLE_PDB}"
        echo "ORACLE_PORT=${env.ORACLE_PORT}"
        echo "ORACLE_PASSWORD=${env.ORACLE_PASSWORD}"
        echo "RETAIN_DB=${env.RETAIN_DB}"
    """

    docker run -d --name ${ORACLE_CNAME} \
        -p ${ORACLE_PORT}:1521 \
        -e ORACLE_PASSWORD=${ORACLE_PASSWORD} \
        -e ORACLE_SID=${ORACLE_SID} \
        #-e ORACLE_PDB=${ORACLE_PDB} \
        -v oradata-${ORACLE_SID}:/opt/oracle/oradata \
        ${ORACLE_IMAGE}

    echo "Container ${ORACLE_CNAME} created successfully."
fi