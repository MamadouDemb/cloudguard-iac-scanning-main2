pipeline {
    agent any
    stages {
        stage('IaC-Syntax-Validation') {
            steps {
                dir('cloudguard-iac-scanning-main2') {
                    git branch: 'main',
                    url: 'https://github.com/MamadouDemb/cloudguard-iac-scanning-main2.git'
                }
                sh '''
                    cd aws

                    terraform --version
                    terraform init
                    terraform validate 
                '''
            }
        }
        stage('CloudGuard_Shiftleft_IAC_Scan') {
            environment {
                CHKP_CLOUDGUARD_ID = credentials("CHKP_CLOUDGUARD_ID")
                CHKP_CLOUDGUARD_SECRET = credentials("CHKP_CLOUDGUARD_SECRET")
                SHIFTLEFT_REGION =  credentials("SHIFTLEFT_REGION")
            }
            agent {
                docker {
                    image 'checkpoint/shiftleft:latest'
                    args '-v /tmp/:/tmp/'
                }
            }
            steps {
                dir('cloudguard-iac-scanning-main2') {
                    git branch: 'main',
                    url: 'https://github.com/MamadouDemb/cloudguard-iac-scanning-main2.git'
                }
                sh '''
                    export SHIFTLEFT_REGION=eu1
                    export CHKP_CLOUDGUARD_ID=$CHKP_CLOUDGUARD_ID
                    export CHKP_CLOUDGUARD_SECRET=$CHKP_CLOUDGUARD_SECRET
                    shiftleft iac-assessment --Infrastructure-Type terraform --path aws --ruleset -64 --severity-level High --Findings-row --environmentId eb691be4-b49c-4ab7-a21c-9414bd0ab62b
                '''
            }
        }
        


    }
}
