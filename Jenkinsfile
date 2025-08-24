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
                    -p ${ORACLE_PORT}:${ORACLE_PORT} \
                    -e ORACLE_PASSWORD=${ORACLE_PASSWORD} \
                    ${ORACLE_IMAGE}
                '''
            }
        }

        stage('Validating Oracle Container') {
            steps {
                    sh '''
                    MAX_INTERVAL=5
                    MAX_RETRIES=30
                    SUCCESS=0

                    for i in \$(seq 1 \$MAX_RETRIES); do
                        RUNNING=\$(docker inspect -f '{{.State.Running}}' ${ORACLE_CNAME})
                        if [ "\$RUNNING" != "true" ]; then
                            echo "Oracle container is not running!"
                            docker logs ${ORACLE_CNAME}
                            exit 1
                        fi

                        OUTPUT=$(docker exec -i ${ORACLE_CNAME} bash -c " <<'EOF'
                        sqlplus -s / as sysdba <<EOSQL
                        SET HEADING OFF;
                        SET FEEDBACK OFF;
                        SELECT status FROM v\\$instance;
                        EXIT;
                        EOSQL
                        EOF
                        " 2>&1)
                        echo "$OUTPUT"

                        if echo "$OUTPUT" | grep -q "OPEN"; then
                            echo "✅ Oracle DB is ready!"
                            SUCCESS=1
                            break
                        fi

                        echo "Waiting for Oracle DB to start... (\$i/\$MAX_RETRIES)"
                        sleep \$MAX_INTERVAL
                    done

                    if [ $SUCCESS -ne 1 ]; then
                        echo "Oracle DB failed to start within expected time."
                        docker logs ${ORACLE_CNAME}
                        exit 1
                    fi

                    # Show last 20 lines of logs for reference
                    docker logs ${ORACLE_CNAME} | tail -n 20
                    echo "Oracle Container ${ORACLE_CNAME} started successfully."
                    '''
            }
        }

        stage('Validation of DB Status'){
            steps{
                sh '''
                sleep 10
                docker exec -i ${ORACLE_CNAME} bash -c "
                sqlplus / as sysdba
                SELECT instance_name, status, open_mode FROM v\\$instance;
                "
                '''
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