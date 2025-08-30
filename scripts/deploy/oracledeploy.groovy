// jenkins/oracleDeploy.groovy
def call(Map config = [:]) {
    pipeline {
        agent any

        environment {
            ORACLE_IMAGE    = config.ORACLE_IMAGE ?: 'gvenzl/oracle-xe'
            ORACLE_CNAME    = config.ORACLE_CNAME ?: 'oracle-db'
            ORACLE_PASSWORD = config.ORACLE_PASSWORD ?: 'oracle'
            ORACLE_PORT     = config.ORACLE_PORT ?: '1521'
            RETAIN_DB       = config.RETAIN_DB ?: 'false'
        }

        stages {
            stage('Prepare Scripts') {
                steps { sh 'chmod +x scripts/deploy/*.sh' }
            }

            stage('Create Oracle Container') {
                steps { sh './scripts/deploy/deploy_create_oracle_container.sh' }
            }

            stage('Validate Oracle Container') {
                steps { sh './scripts/deploy/deploy_validate_oracle_container.sh' }
            }

            stage('Final DB & Listener Validation') {
                steps { sh './scripts/deploy/deploy_final_validate.sh' }
            }
        }

        post {
            always {
                sh '''
                echo "Cleaning up..."
                if [ "${RETAIN_DB}" != "true" ]; then
                    docker stop ${ORACLE_CNAME}
                    docker rm ${ORACLE_CNAME}
                fi
                '''
            }
        }
    }
}