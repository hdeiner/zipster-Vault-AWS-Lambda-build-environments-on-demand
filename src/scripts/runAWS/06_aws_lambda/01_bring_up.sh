#!/usr/bin/env bash
figlet -w 200 -f standard "Bring Up AWS-QA-LAMBDA"
export ENVIRONMENT=AWS-QA-LAMBDA

figlet -w 200 -f small "Compile and Package Zipster"
cd ../../../
mvn -q clean compile package
cd -

figlet -w 200 -f small "Gather Vault connection for Lambda Terraform"
export VAULT_ADDRESS="http://"$(<../../iac/terraform/vault/.vault_dns)":8200"
echo "VAULT_ADDRESS is "$VAULT_ADDRESS
mkdir .vault_howardeiner
aws s3 cp s3://zipster-aws-on-demand-vault/root_token .vault_howardeiner/root_token
export VAULT_TOKEN=$(<.vault_howardeiner/root_token)
echo "VAULT_TOKEN is "$VAULT_TOKEN

figlet -w 200 -f small "Terraform the environment"
cd ../../iac/terraform/awsqa_lambda
terraform apply -var environment=$ENVIRONMENT -auto-approve
terraform output zipster_url > .zipster_url
cd -

figlet -w 200 -f small "Pause for environment to settle"
sleep 10

figlet -w 200 -f small "Verify Deployment"
aws lambda list-functions --region "us-east-1"

#vault login -address=$VAULT_ADDRESS $VAULT_TOKEN > /dev/null

#export SPARK_DNS_NAME=$(echo `cat ../../iac/terraform/awsqa_swarm/.spark_swarm_manager_dns`)
#vault kv put -address=$VAULT_ADDRESS ENVIRONMENTS/$ENVIRONMENT/SPARK/ address=$SPARK_DNS_NAME > /dev/null
#echo "SPARK_DNS_NAME is "$SPARK_DNS_NAME

#rm -rf .vault_howardeiner
