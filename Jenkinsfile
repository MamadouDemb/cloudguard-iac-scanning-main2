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
                dir('iac-code') {
                    git branch: 'main',
                    url: 'https://github.com/MamadouDemb/cloudguard-iac-scanning-main2.git'
                }
                sh '''
                    export SHIFTLEFT_REGION=eu1
                    export CHKP_CLOUDGUARD_ID=$CHKP_CLOUDGUARD_ID
                    export CHKP_CLOUDGUARD_SECRET=$CHKP_CLOUDGUARD_SECRET
                    shiftleft iac-assessment --path aws --ruleset -46 --severity-level High  --environmentId ec00ab44-b2a5-4d4d-9746-ffaa110dd3b4 || if ["$?" == "6" ]; then exit 0 ; fi
                '''
            }
        }



    }
}
