pipeline {
    agent any

    environment {
        ORACLE_IMAGE = 'gvenzl/oracle-xe'
        ORACLE_CNAME = 'oracle-db'
        ORACLE_PASSWORD = 'oracle'
        ORACLE_PDB = 'USERS'
        ORACLE_HOME = '/opt/oracle/product/21c/dbhome_1'
        ORACLE_PORT = 1521
    }

    stages {

        stage('Checking for Conflicting Container Names') {

            steps {
                sh '''
                    while [ \$(docker ps -a -q -f name=\${ORACLE_CNAME}) ]; do
                        sh """
                        echo "Container \${ORACLE_CNAME} already exists. Removing it..."
                        docker stop \${ORACLE_CNAME}
                        docker rm \${ORACLE_CNAME}
                        echo "Container \${ORACLE_CNAME} has been removed Successfully. Checking for additional containers..."
                        """
                    done
                    echo "Container \${ORACLE_CNAME} is not running."
                '''
            }
        }

        stage('Pulling Oracle Image gvenzl/oracle-xe') {
            steps {
                sh """
                    if [ -z "\$(docker images -q \$ORACLE_IMAGE)" ]; then
                        echo "Docker Image not found. Pulling..."
                        docker pull \${ORACLE_IMAGE}
                    
                    else
                        echo "Local Docker Image is Available. Hence Proceeding With The Old Image."
                    fi
                """
            }
        }

        stage('Starting Oracle Container') {
            steps {
                sh '''
                    docker run -d --name ${ORACLE_CNAME} \
                    -e ORACLE_PWD=${ORACLE_PASSWORD} \
                    -e ORACLE_PDB=${ORACLE_PDB} \
                    -e ORACLE_HOME=${ORACLE_HOME} \
                    -p ${ORACLE_PORT}:1521 \
                    ${ORACLE_IMAGE}
                '''
            }
        }

        stage('Validating Oracle Container') {
            steps {
                sh """
                    MAX_INTERVAL=5
                    MAX_RETRIES=30

                    for i in \$(seq 1 \$MAX_RETRIES); do
                        RUNNING=\$(docker inspect -f '{{.State.Running}}' ${ORACLE_CNAME})
                        if [ "\$RUNNING" != "true" ]; then
                            echo "Oracle container is not running!"
                            docker logs ${ORACLE_CNAME}
                            exit 1
                        fi
                """

                    # Try a simple SQL command inside container
                    sh"""
                    if docker exec -i ${ORACLE_CNAME} sqlplus -s / as sysdba <<EOF | grep -q "1"
                    SELECT 1 FROM dual;
                    EXIT;
                    EOF
                    then
                        echo "Oracle DB is ready!"
                        break
                    fi

                    echo "Waiting for Oracle DB to start... (\$i/\$MAX_RETRIES)"
                    sleep \$MAX_INTERVAL
                    done

                    # If DB not ready after max retries
                    if [ "\$i" == "\$MAX_RETRIES" ]; then
                        echo "Oracle DB failed to start within expected time."
                        docker logs ${ORACLE_CNAME}
                        exit 1
                    fi

                    # Show last 20 lines of logs for reference
                    docker logs ${ORACLE_CNAME} | tail -n 20
                    echo "Oracle Container ${ORACLE_CNAME} started successfully."                  
                """
            }
        }
    }

    post {
        always {
            sh '''
                docker stop ${ORACLE_CNAME}
                docker rm ${ORACLE_CNAME}
                #cleanWs()
            '''
        }
    }
}