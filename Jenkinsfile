pipeline {
    agent any
    stages {
        stage('CloudGuard_Shiftleft_IaC') {
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
                    shiftleft iac-assessment -l S3Bucket should have encryption.serverSideEncryptionRules -p ./aws
                '''
            }
        }



    }
}
