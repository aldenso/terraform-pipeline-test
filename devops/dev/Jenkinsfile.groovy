pipeline {
    agent any
    environment {
        TF_VAR_prefix   = params.PREFIX
        TF_VAR_size = params.SIZE
    }
    stages {
        stage('Stage 1') {
            steps {
                withCredentials([string(credentialsId: 'AZTENANT-DEV', variable: 'AZTENANT'),
                                string(credentialsId: 'AZSUBSCRIPTION-DEV', variable: 'AZSUBSCRIPTION'),
                                string(credentialsId: 'AZCLIENT-DEV', variable: 'AZCLIENT'),
                                file(credentialsId: 'AZCERTIFICATE-DEV', variable: 'AZCERTIFICATE')]) {
                                environment {
                                    ARM_CLIENT_ID = "${AZCLIENT}"
                                    ARM_CLIENT_CERTIFICATE_PATH = "${AZCERTIFICATE}"
                                    ARM_SUBSCRIPTION_ID = "${AZSUBSCRIPTION}"
                                    ARM_TENANT_ID = "${AZTENANT}"
                                }
                    terraform init
                    terraform plan
                }
            }
        }
    }
}