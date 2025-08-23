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
        stage('Check for previous docker containers with the same name') {
            steps {
                sh '''
                    if [ $(docker ps -a -q -f name=${ORACLE_CNAME}) ]; then
                        echo "Container ${ORACLE_CNAME} is already running."
                    else
                        echo "Container ${ORACLE_CNAME} is not running."
                    fi
                '''
            }
        }
    }
}