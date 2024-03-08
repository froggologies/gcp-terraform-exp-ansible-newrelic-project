# GCP - Terraform - Ansible - New Relic - Nginx

## Requirement

- Google Cloud Platform:
    - Folder
    - Billing Account
    - Cloud Storage (optional, to save terraform state)

## Prerequisite

1. Install Terraform
2. Install Ansible
3. Clone this repo

```sh
git clone https://github.com/froggologies/gcp-terraform-exp-ansible-newrelic-project
cd gcp-terraform-exp-ansible-newrelic-project
```

## Terraform

This terraform will create the following:
- Project
- Enable services
- Restore policy
- VPC
- Subnet (us-central1)
- Firewall
- GCE instance
- Service account

1. Create environment variables

```sh
export TF_VAR_folder_id=<folder-id>
export TF_VAR_billing_account=<billing-account-id>
```

If using service account

```sh
export GOOGLE_APPLICATION_CREDENTIALS=<sa-key-json-file>
```

2. Initializes terraform

```sh
terraform -chdir=terraform init
```

3. Apply terraform

```sh
terraform -chdir=terraform apply -auto-approve
```

> Your account might not have the requisite permissions for accessing all necessary features. Adjust permissions accordingly.

4. Get the GCE instance external IP

```sh
terraform -chdir=terraform output

# output:
# instance-1 = "ip-address"
```

Copy the IP address.

## Ansible
