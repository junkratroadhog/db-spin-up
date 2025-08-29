pipeline {
    agent any

    environment {
        ORACLE_IMAGE = 'gvenzl/oracle-xe'
        ORACLE_CNAME = 'oracle-db'
        ORACLE_PASSWORD = 'oracle'
        ORACLE_PORT = 1521
        // ORACLE_PDB = 'USERS'                                 // This parameter wont work
        // ORACLE_HOME = '/opt/oracle/product/21c/dbhome_1'     // This parameter wont work
    }

    stages {

        stage('Scripts List and Permission check') {
            steps{
                sh 'chmod +x scripts/deploy/*.sh'
            }
        }

        stage("Creating Oracle DB in Docker Container") {
            steps {
                sh '''
                ./scripts/deploy/deploy_create_oracle_container.sh
                '''
            }
        }

        stage('Validating Oracle DB in Container') {
            steps {
                    sh '''
                    ./scripts/deploy/deploy_validate_oracle_container.sh
                    '''
            } 
        }

        stage('Validation of DB & Listener Status'){
            steps{
                sh '''
                    ./scripts/deploy/deploy_final_validate.sh
                '''
            }
        }
    }

    post {
        always {
            sh ''' 
                echo "Cleaning up..."
                docker stop ${ORACLE_CNAME}
                docker rm ${ORACLE_CNAME}
            '''
        }
    }      
}