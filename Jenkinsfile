pipeline {
    agent any
    stages {
        stage('CloudGuard_Shiftleft_IaC') {
            environment {
                CHKP_CLOUDGUARD_CREDS = credentials(CloudGuard_Credentials)
            }
            agent {
                docker {
                    image 'checkpoint/shiftleft:latest'
                    args '-v /tmp/:/tmp/'
                }
            }
            steps {
                dir('iac-code') {
                    git branch: '{banch}',
                    credentialsId: '{jenkins_credentials_id_for_git_credentials}',
                    url: {git_repo_url}'
                }
                sh '''
                    export CHKP_CLOUDGUARD_ID=$CHKP_CLOUDGUARD_CREDS_USR
                    export CHKP_CLOUDGUARD_SECRET=$CHKP_CLOUDGUARD_CREDS_PSW
                    shiftleft iac-assessment -i terraform -p iac-code/terraform-template -r {rulesetId} -e {environmentId}
                '''
            }
        }
        stage('CloudGuard_Shiftleft_Code_Scan') {
            environment {
                CHKP_CLOUDGUARD_CREDS = credentials(CloudGuard_Credentials)
            }
            agent {
                docker {
                    image 'checkpoint/shiftleft:latest'
                    args '-v /tmp/:/tmp/'
                }
            }
            steps {
                dir('code-dir') {
                    git branch: '{banch}',
                    credentialsId: '{jenkins_credentials_id_for_git_credentials}',
                    url: {git_repo_url}'
                }
                sh '''
                    export CHKP_CLOUDGUARD_ID=$CHKP_CLOUDGUARD_CREDS_USR
                    export CHKP_CLOUDGUARD_SECRET=$CHKP_CLOUDGUARD_CREDS_PSW
                    shiftleft code-scan -s code-dir -r {rulesetId} -e {environmentId}
                '''
            }
        }
    }
}