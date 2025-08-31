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

    docker run -d --name ${ORACLE_CNAME} \
        -p ${ORACLE_PORT}:1521 \
        -e ORACLE_PASSWORD=${ORACLE_PASSWORD} \
        ${ORACLE_IMAGE}
    

    echo "Container ${ORACLE_CNAME} created successfully."
fi