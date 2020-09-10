#!/usr/bin/env bash

figlet -w 200 -f standard "Bring Down AWS-QA-LAMBDA"
export ENVIRONMENT=AWS-QA-LAMBDA

figlet -w 160 -f small "Remove ENVIRONMENT from Vault"
export VAULT_ADDRESS="http://"$(<../../iac/terraform/vault/.vault_dns)":8200"
mkdir .vault_howardeiner
aws s3 cp s3://zipster-aws-on-demand-vault/root_token .vault_howardeiner/root_token
export VAULT_TOKEN=$(<.vault_howardeiner/root_token)
vault login -address=$VAULT_ADDRESS $VAULT_TOKEN > /dev/null

for path in $(vault kv list -address=$VAULT_ADDRESS ENVIRONMENTS/AWS-QA-LAMBDA/ | tail -n+3);
  do
    vault kv delete -address=$VAULT_ADDRESS ENVIRONMENTS/AWS-QA-LAMBDA/${path};
  done

figlet -w 200 -f small "UnTerraform AWS-QA-LAMBDA"
cd ../../iac/terraform/awsqa_lambda
terraform destroy -var environment=AWS-QA-LAMBDA -auto-approve
rm -rf .environment .mysql_dns .zipster_url
cd -

cd ../../../
mvn -q clean
cd -

rm -rf .vault_howardeiner


