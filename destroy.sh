#!/usr/bin/env bash
# Removes everything Terraform created (stops AWS charges).
set -euo pipefail
cd "$(dirname "$0")/terraform"
terraform destroy -auto-approve -input=false
echo "All resources destroyed."
