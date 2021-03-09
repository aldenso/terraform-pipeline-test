try {
    node {
        env.TF_VAR_prefix = "${params.PREFIX}"
        env.TF_VAR_size = "${params.SIZE}"

        checkout scm

        stage('Stage 1') {
            withCredentials([string(credentialsId: 'AZTENANT-DEV', variable: 'AZTENANT'),
                            string(credentialsId: 'AZSUBSCRIPTION-DEV', variable: 'AZSUBSCRIPTION'),
                            string(credentialsId: 'AZCLIENT-DEV', variable: 'AZCLIENT'),
                            file(credentialsId: 'AZCERTIFICATE-DEV', variable: 'AZCERTIFICATE')]) {
                env.ARM_CLIENT_ID = "${AZCLIENT}"
                env.ARM_CLIENT_CERTIFICATE_PATH = "${AZCERTIFICATE}"
                env.ARM_SUBSCRIPTION_ID = "${AZSUBSCRIPTION}"
                env.ARM_TENANT_ID = "${AZTENANT}"
                sh "terraform init"
                sh "terraform plan"
                }
        }
        cleanWs()
    }
} catch (Exception e) {
    node {
        cleanWs()
        throw e
    }
}
