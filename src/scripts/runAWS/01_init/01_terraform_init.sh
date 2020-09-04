#!/usr/bin/env bash

figlet -w 160 -f standard "Terraform Init"

figlet -w 160 -f small "Init Vault Server"
cd ../../iac/terraform/vault
terraform init
cd -

figlet -w 160 -f small "Init AWS-QA-LAMBDA"
cd ../../iac/terraform/awsqa_lambda
terraform init
cd -
