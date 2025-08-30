pipeline {
    agent any

    stages {
        stage('Deploy Oracle DB') {
            steps {
                script {
                    build job: 'db-spin-up/ora-test',
                        parameters: [
                            string(name: 'CONFIG', value: 'ORACLE_IMAGE=gvenzl/oracle-xe,ORACLE_CNAME=usersdb,ORACLE_PORT=1525,RETAIN_DB=true')
                        ]
                }
            }
        }
    }
}