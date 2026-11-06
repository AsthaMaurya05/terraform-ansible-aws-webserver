# Automated Web Server Deployment on AWS using Terraform and Ansible

**Course:** INT333 - DevOps Advance Configuration Management
**Student:** Astha Maurya (Reg. No. 12300541), B.Tech CSE
**Project Guide:** Dr. Harpreet Kaur

## Overview
Creating servers and installing software by hand is slow, repetitive and error-prone.
This project automates it end to end:

- **Terraform** provisions an AWS EC2 server, a security group (ports 22 and 80) and an SSH key pair.
- Terraform then **writes the Ansible inventory** with the new server's public IP (the integration point).
- **Ansible** configures the server: updates packages, installs Nginx, creates a dedicated user,
  deploys a static website, and verifies that the site responds.

The whole environment can be created with one command and destroyed and recreated with identical configuration.

## Architecture

    Control machine (Ubuntu)
      |-- Terraform ----> AWS (ap-south-1): Key pair + Security group (22, 80) + EC2 (Ubuntu 22.04)
      |        '--> writes ansible/inventory.ini (public IP)
      '-- Ansible --SSH--> EC2: Nginx + user "webdeploy" + website
    Browser --HTTP :80--> EC2

## Repository structure

    terraform/   versions.tf provider.tf variables.tf main.tf outputs.tf inventory.tpl
    ansible/     ansible.cfg playbook.yml vars.yml templates/
    deploy.sh    one-command deployment (Terraform then Ansible)
    destroy.sh   removes all AWS resources
    evidence/    logs of tests, destroy and rebuild

## Prerequisites
Ubuntu control machine with Terraform, Ansible and AWS CLI installed;
an AWS IAM user with EC2 access configured via `aws configure`;
an SSH key pair at ~/.ssh/int333_key (create with: ssh-keygen -t ed25519 -f ~/.ssh/int333_key -N "").

## Usage

    ./deploy.sh      # build server and deploy website
    ./destroy.sh     # remove everything

Manual steps: `cd terraform && terraform init && terraform apply`, then `cd ../ansible && ansible-playbook playbook.yml`.

## Features
- Input validation on Terraform variables (rejects invalid instance types before anything is created)
- Idempotent playbook (second run reports changed=0)
- Handlers: Nginx is tested and reloaded only when its configuration changes
- block/rescue verification with diagnostics if the website check fails
- Tags for partial runs (packages, user, website, nginx, verify)
- Security hardening: IMDSv2 enforced, encrypted EBS volume, Nginx version hidden, security headers,
  no credentials in code

## Tests

| # | Test | Result |
|---|------|--------|
| 1 | Website returns HTTP 200 with correct title | Pass |
| 2 | Re-run playbook: changed=0 (idempotency) | Pass |
| 3 | Stop Nginx, re-run: service restored | Pass |
| 4 | Delete index.html, re-run: file redeployed | Pass |
| 5 | Invalid instance_type rejected by Terraform | Pass |
| 6 | Destroy and rebuild gives the same configuration | Pass |

Logs are in `evidence/`.

## References
1. HashiCorp, Terraform Documentation - https://developer.hashicorp.com/terraform/docs
2. Red Hat, Ansible Documentation - https://docs.ansible.com/
3. Amazon Web Services, Amazon EC2 Documentation - https://docs.aws.amazon.com/ec2/
4. Terraform Registry, AWS Provider - https://registry.terraform.io/providers/hashicorp/aws/latest/docs
5. Nginx Documentation - https://nginx.org/en/docs/
