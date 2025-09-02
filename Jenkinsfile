pipeline {
    agent any

    stages {

        stage('Parallel DB Deploy') {
            
            steps {
                script {
                    def ORACLE_IMAGE = 'container-registry.oracle.com/database/enterprise:21.3.0.0'

                    parallel(
                        'Deploy Users DB': {
                            def CONFIG = 
                                "ORACLE_IMAGE=${ORACLE_IMAGE}," +
                                "ORACLE_CNAME=db-users," +
                                "ORACLE_SID=USERSPDB," +
                                "ORACLE_PDB=USERS_PDB," +
                                "ORACLE_PORT=1525," +
                                "RETAIN_DB=true," +
                                "STOP_DB=false"

                            build job: 'deploy-oracle-db',
                                parameters: [ string(name : 'CONFIG', value: CONFIG) ]
                            echo "Triggered job 'deploy-oracle-db' with parameters:\n${CONFIG.replaceAll(',', '\n')}"
                        },

                        'Deploy Details DB': {
                            def CONFIG = 
                                "ORACLE_IMAGE=${ORACLE_IMAGE}," +
                                "ORACLE_CNAME=db-details," +
                                "ORACLE_SID=DETAILS," +
                                "ORACLE_PDB=DETAILS_PDB," +
                                "ORACLE_PORT=1526," +
                                "RETAIN_DB=true," +
                                "STOP_DB=false"

                            build job: 'deploy-oracle-db',
                                parameters: [ string(name : 'CONFIG', value: CONFIG) ]
                            echo "Triggered job 'deploy-oracle-db' with parameters:\n${CONFIG.replaceAll(',', '\n')}"
                        }
                    )
                }
            }
        }
    }
}