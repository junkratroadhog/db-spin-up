pipeline {
    agent any

    environment {
        ORACLE_IMAGE = 'gvenzl/oracle-xe'
        ORACLE_CNAME = 'oracle-db'
        ORACLE_PASSWORD = 'oracle'
        //ORACLE_PDB = 'USERS'
        //ORACLE_HOME = '/opt/oracle/product/21c/dbhome_1'
        ORACLE_PORT = 1521
    }

    stages {

        stage("Copy Scripts"){
            steps {
                sh '''
                docker cp scripts/create_oracle_container.sh ${ORACLE_CNAME}:/tmp/create_oracle_container.sh
                docker cp scripts/validate_oracle_container.sh ${ORACLE_CNAME}:/tmp/validate_oracle_container.sh
                docker cp scripts/db-health-check.sql ${ORACLE_CNAME}:/tmp/db-health-check.sql
                '''
            }
        }

        stage("Creating Oracle DB in Docker Container") {
            steps {
                sh '/tmp/create_oracle_container.sh'
            }
        }

        stage('Validating Oracle DB in Container') {
            steps {
                    sh '/tmp/validate_oracle_container.sh'
            }
        }

        stage('Validation of DB & Listener Status'){
            steps{
                sh '''
                docker exec -i ${ORACLE_CNAME} sqlplus -s / as sysdba @/tmp/db-health-check.sql
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