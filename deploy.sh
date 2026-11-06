#!/usr/bin/env bash
# One-command deployment: Terraform builds the server, Ansible configures it.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "==> [1/3] Terraform: provisioning infrastructure"
cd "$ROOT/terraform"
terraform init -input=false
terraform apply -auto-approve -input=false

echo "==> [2/3] Waiting for the server to accept SSH"
cd "$ROOT/ansible"
ansible webservers -m wait_for_connection -a "timeout=180"

echo "==> [3/3] Ansible: configuring server and deploying website"
ansible-playbook playbook.yml

echo
echo "DONE. Website: $(cd "$ROOT/terraform" && terraform output -raw website_url)"
