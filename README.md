# GCP - Terraform - Ansible - New Relic - Nginx

## TODO
- Update documentation about New Relic deployment on GKE
- Tidy up ansible files

## Requirement

- Google Cloud Platform:
    - Folder
    - Billing Account
    - Cloud Storage (optional, to save terraform state)
- New Relic:
    - API key
    - Account ID

## Prerequisite

1. Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

Install newrelic ansible-galaxy

```sh
ansible-galaxy install newrelic.newrelic_install
```

Make sure you have ansible.windows and ansible.utils if they are not already installed:

```sh
ansible-galaxy collection install ansible.windows ansible.utils
```

3. Clone this repo

```sh
git clone https://github.com/froggologies/gcp-terraform-exp-ansible-newrelic-project
cd gcp-terraform-exp-ansible-newrelic-project
```

## Terraform

This terraform section will create the following:
- Project
- Enable services
- Restore policy
- VPC
- Subnet (us-central1)
- Firewall
- Service account
- GCE instance
- Metadata

1. Create environment variables

```sh
export TF_VAR_folder_id=<folder-id>
export TF_VAR_billing_account=<billing-account-id>
```

If using service account

```sh
export GOOGLE_APPLICATION_CREDENTIALS=<sa-key-json-file>
```

2. Change the backend location

In the terraform/backend.tf, change the bucket name to your bucket name.

`bucket = "<bucket-name>"`

> You could also remove the entire code in backend.tf if you want to save terraform state in the local machine.

3. Change the ssh public key path in terraform/compute_instance.tf in `ssh-keys = "ansible:${file("<ssh-public-key-path>")}"` to your public ssh key.

Here is how to generate ssh key pair if you don't have it yet:

```sh
ssh-keygen -t rsa -f ~/.ssh/ansible -C ansible -b 2048
```

4. Initializes terraform

```sh
terraform -chdir=terraform init
```

5. Apply terraform

```sh
terraform -chdir=terraform apply -auto-approve
```

> Your account might not have the requisite permissions for accessing all necessary features. Adjust permissions accordingly.

6. Get the GCE instance external IP

```sh
terraform -chdir=terraform output

# output:
# instance-1 = "ip-address"
```

Copy the IP address.

## Ansible

This Ansible section will do the following:
- Install nginx
- Enable stub status nginx module
- Install New Relic Integration:
    - infrastucture
    - logs
    - nginx

1. Change to the ansible dir

```sh
cd ansible
```

2. Paste the previous IP address to inventory.yaml in here `ansible_host: <host-ip>`

3. Configure the ansible.cfg

```
private_key_file= <ssh-private-key-path>
remote_user = <username>
```

4. Configure New Relic environment variables in install_new_relic.yaml

```yaml
NEW_RELIC_API_KEY: <nr-api-key>
NEW_RELIC_ACCOUNT_ID: <nr-account-id>
NEW_RELIC_REGION: <region-ex:US/EU>
```

5. Install nginx

```sh
ansible-playbook -i inventory.yaml install_nginx.yaml
```

6. Install New Relic Integration

```sh
ansible-playbook -i inventory.yaml install_new_relic.yaml
```