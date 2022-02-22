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
                    shiftleft iac-assessment -l "aws_s3_bucket should not have tags.Name"  -p aws || if ["$?" == "6" ]; then exit 0 ; fi
                '''
            }
        }
        stage('CloudGuard_Shiftleft_IAC_Execution_Plan_Scan') {
            environment {
               AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
               AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
               AWS_DEFAULT_REGION =  credentials('AWS_DEFAULT_REGION')
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
                sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    export AWS_DEFAULT_REGION="eu-west-1"

                    terraform --version                    
                    terraform plan --out=tf-plan-file 
                    terraform show --json tf-plan-file > plan-file.json
                    
                    export SHIFTLEFT_REGION=eu1
                    export CHKP_CLOUDGUARD_ID=$CHKP_CLOUDGUARD_ID
                    export CHKP_CLOUDGUARD_SECRET=$CHKP_CLOUDGUARD_SECRET
                    shiftleft iac-assessment --Infrastructure-Type terraform --path ./plan-file.json --ruleset -64 --severity-level Critical --Findings-row --environmentId fb66d8cd-8955-4c6d-a050-adcf2b890287
                '''
            }
        }
        
        stage('IAC_Provider_Cleanup') {
            steps {
                sh '''
                    du -sh
                    rm plan-file.json
                    rm -r .terraform
                    rm -r .terraform.lock.hcl
                    du -sh
                '''
            }
        }


    }
}
