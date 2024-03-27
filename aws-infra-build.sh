#!/usr/bin/bash
echo "" && echo "===> git pull for any repo updates"
# rm -rf infra-build/terraform.tfvars
git pull

# echo "" && echo "===> Change directory backwards to run ansible"
# cd .. && ansible-playbook ignition-files.yml && cd infra-build


echo "" && echo "===> Change directory to run terraform"
cd infra-build/ && terraform init && terraform apply
cd ..

