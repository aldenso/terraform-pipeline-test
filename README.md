# terraform-pipeline-test

Test repo for terraform jenkins pipelines for VM creation, used in conjuntion with [jenkins-jcasc](https://github.com/aldenso/jenkins-jcasc-demo)

Minimal requisites to run manually.

- Azure Subscription (ARM_SUBSCRIPTION_ID)
- Azure Tenant (ARM_TENANT_ID)
- Azure Service Principal (ARM_CLIENT_ID)
- Azure Certificate Associated with Service Principal (ARM_CLIENT_CERTIFICATE_PATH)
- Azure Storage Account
  - Azure container in storage account
  - Azure Storage Account Access Key (ARM_ACCESS_KEY) - for Terraform Remote Backend.

Once you have all the info export it as environment variables.

```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_CERTIFICATE_PATH="/your/path/file.pfx"
export ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
export TF_VAR_username=azureuser
export TF_VAR_password=myvery01Secure@ccess # remember to follow azure password guidelines
export ARM_ACCESS_KEY='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
export TF_VAR_prefix=WHATYOUWANT
```

**Note**: Changed the backend configuration in 'main.tf' to point to your configuration.
