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

        stage("Creating Oracle DB in Docker Container") {
            steps {
                sh '''
                    if [ \$(docker ps -a -q -f name=\${ORACLE_CNAME}) ]; then
                        echo "Container \${ORACLE_CNAME} already exists. Hence starting it..."
                        docker start \${ORACLE_CNAME}
                        echo "Container \${ORACLE_CNAME} has been started Successfully."
                    
                    else
                        if [ -z "\$(docker images -q \$ORACLE_IMAGE)" ]; then
                            echo "Docker Image not found. Pulling..."
                            docker pull \${ORACLE_IMAGE}
                        else
                            echo "Local Docker Image is Available. Hence Proceeding With The Old Image."
                        fi

                        docker run -d --name ${ORACLE_CNAME} \
                        -p ${ORACLE_PORT}:${ORACLE_PORT} \
                        -e ORACLE_PASSWORD=${ORACLE_PASSWORD} \
                        ${ORACLE_IMAGE}
                        echo "Container \${ORACLE_CNAME} Has Been Created Successfully."
                    fi
                '''
            }
        }

        stage('Validating Oracle DB in Container') {
            steps {
                    sh '''
                    MAX_INTERVAL=20
                    MAX_RETRIES=3
                    SUCCESS=0

                    for i in \$(seq 1 \$MAX_RETRIES); do
                        echo "Waiting for Oracle DB to start... (\$i/\$MAX_RETRIES)"
                        sleep \$MAX_INTERVAL
                        RUNNING=\$(docker inspect -f '{{.State.Running}}' ${ORACLE_CNAME})
                        if [ "\$RUNNING" != "true" ]; then
                            echo "Oracle container is not running!"
                            docker logs ${ORACLE_CNAME}
                            exit 1
                        fi

                        if [ \$i -le \$MAX_RETRIES ]; then
                            docker cp scripts/validate_db.sql oracle-db:/tmp/validate_db.sql
                            OUTPUT=$(docker exec -i ${ORACLE_CNAME} sqlplus -s / as sysdba @/tmp/validate_db.sql)
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
                    '''
            }
        }

        stage('Validation of DB Status'){
            steps{
                sh '''
                docker cp scripts/db-ls-status.sql ${ORACLE_CNAME}:/tmp/db-ls-status.sql
                docker exec -i ${ORACLE_CNAME} sqlplus -s / as sysdba @/tmp/db-ls-status.sql
                docker exec -i ${ORACLE_CNAME} lsnrctl status
                '''
            }
        }
    }

    post {
        always {
            sh ''' 
                echo "Cleaning up..."
                #docker stop ${ORACLE_CNAME}
                #docker rm ${ORACLE_CNAME}
                #cleanWs()
            '''
        }
    }      
}