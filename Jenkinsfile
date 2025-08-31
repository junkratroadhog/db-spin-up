pipeline {
    agent any

    stages {
        
        stage('Deploy Users DB') {
            
            steps {
                script {
                    build job: 'deploy-oracle-db',
                        parameters: [
                            string(name: 'CONFIG', 
                            value: 'ORACLE_IMAGE=gvenzl/oracle-xe,ORACLE_CNAME=usersdb,ORACLE_PORT=1525,RETAIN_DB=true')
                        ]
                    echo "Triggered job 'deploy-oracle-db' with parameters: ORACLE_IMAGE=gvenzl/oracle-xe,ORACLE_CNAME=usersdb,ORACLE_PORT=1525,RETAIN_DB=true"
                }
            }
        }

        stage('Deploy Details DB') {
            
            steps {
                script {
                    build job: 'deploy-oracle-db',
                        parameters: [
                            string(name: 'CONFIG', 
                            value: 'ORACLE_IMAGE=gvenzl/oracle-xe,ORACLE_CNAME=detailsdb,ORACLE_PORT=1525,RETAIN_DB=true')
                        ]
                    echo "Triggered job 'deploy-oracle-db' with parameters: ORACLE_IMAGE=gvenzl/oracle-xe,ORACLE_CNAME=detailsdb,ORACLE_PORT=1525,RETAIN_DB=true"
                }
            }
        }
    }
}