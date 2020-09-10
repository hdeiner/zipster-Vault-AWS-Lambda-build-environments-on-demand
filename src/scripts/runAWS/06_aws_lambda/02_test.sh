#!/usr/bin/env bash

figlet -w 200 -f standard "Test in AWS-QA-LAMBDA Environment"

#export ENVIRONMENT=AWS-QA-LAMBDA
#
#export VAULT_ADDRESS="http://"$(<../../iac/terraform/vault/.vault_dns)":8200"
#mkdir .vault_howardeiner
#aws s3 cp s3://zipster-aws-on-demand-vault/root_token .vault_howardeiner/root_token
#export VAULT_TOKEN=$(<.vault_howardeiner/root_token)
#vault login -address=$VAULT_ADDRESS $VAULT_TOKEN > /dev/null
#
#export SPARK_DNS_NAME=`vault kv get -address=$VAULT_ADDRESS ENVIRONMENTS/$ENVIRONMENT/SPARK | grep -E '^address[ ]*.' | awk '{print $2}'`
#
#TEST_COMMAND="curl -X GET 'http://"$SPARK_DNS_NAME":8080/zipster?zipcode=07440&radius=2'"
#echo $TEST_COMMAND
#eval $TEST_COMMAND
#
#rm -rf .vault_howardeiner

#TEST_COMMAND="curl "`cat ../../iac/terraform/awsqa_lambda/.zipster_url`" -d '{\"radius\":\"2.0\",\"zipcode\":\"07440\"}'"
TEST_COMMAND="curl "`cat ../../iac/terraform/awsqa_lambda/.zipster_url`" -H 'Cache-Control: no-cache' -H 'Content-Type: application/json' -H 'x-api-key: *****************************' -d '{\"zipcode\":\"07440\",\"radius\":\"2.0\"}'"
echo $TEST_COMMAND
eval $TEST_COMMAND
#curl https://0aslp8bygg.execute-api.us-east-1.amazonaws.com/reference_implementation/zipster -H 'Cache-Control: no-cache' -H 'Content-Type: application/json' -H 'x-api-key: *****************************'  -d '{ "requestMessage": "Sidath"}'
echo ""