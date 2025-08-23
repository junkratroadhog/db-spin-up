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
                sh '''
                    docker pull ${ORACLE_IMAGE}
                '''
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
                    sleep 20
                    echo "Oracle Container ${ORACLE_CNAME} started successfully."
                    sqlplus / as sysdba
                    select name, open_mode, database_role, db_unique_name from v$database;
                    exit;
                '''
            }
        }
    }
}