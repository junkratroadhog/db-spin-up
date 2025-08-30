pipeline {
    agent any

    stages {
        stage('Deploy Oracle DB') {
            steps {
                script {
                    def configStr = 'ORACLE_IMAGE=gvenzl/oracle-xe,ORACLE_CNAME=usersdb,ORACLE_PORT=1525,RETAIN_DB=true'
                    build job: 'deploy-oracle-db',
                        parameters: [
                            string(name: 'CONFIG', value: configStr)
                        ]
                    echo "Triggered job 'deploy-oracle-db' with parameters: ${configStr}"
                }
            }
        }
    }
}