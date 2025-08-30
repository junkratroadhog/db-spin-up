def oracleDeploy = load 'jenkins/oracleDeploy.groovy'

pipeline {
    agent any

    stages {
        stage('Deploy Oracle QA') {
            steps {
                script {
                    oracleDeploy(
                        ORACLE_CNAME: 'qa-db',
                        ORACLE_PORT: '1522',
                        RETAIN_DB: 'true'
                    )
                }
            }
        }

        stage('Deploy Oracle Dev') {
            steps {
                script {
                    oracleDeploy(
                        ORACLE_CNAME: 'dev-db',
                        ORACLE_PORT: '1523',
                        RETAIN_DB: 'false'
                    )
                }
            }
        }
    }
}