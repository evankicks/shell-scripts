#!/bin/bash

echo ================================...checking if jq installed on the machine...=================================
brew list | grep jq



if [ $? -eq 0 ]; then echo "jq installed" 
else brew install jq 
fi

echo ************************************************************************************************************

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_DEFAULT_REGION

echo -n "Enter mfa_arn: "
read mfa_arn
echo $mfa_arn

echo -n "Enter mfa_code: "
read mfa_code
echo $mfa_code

echo -n "Enter aws_profile: "
read aws_profile
echo $aws_profile

echo -n "enter aws region: "
read aws_default_region
echo $aws_default_region

TOKEN=$( aws sts get-session-token --serial-number $mfa_arn  --token-code $mfa_code --profile $aws_profile --duration-seconds 3600 )



export AWS_ACCESS_KEY_ID="$(echo "$TOKEN" | jq '.Credentials.AccessKeyId' | sed 's/"//g')"

export AWS_SECRET_ACCESS_KEY="$(echo "$TOKEN" | jq '.Credentials.SecretAccessKey' | sed 's/"//g')"
 
export AWS_SESSION_TOKEN="$(echo "$TOKEN" | jq '.Credentials.SessionToken' | sed 's/"//g')"
 
export AWS_DEFAULT_REGION="$aws_default_region"


echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_SESSION_TOKEN
echo $AWS_DEFAULT_REGION

# To execute the script successfully, run the script with source(i.e   source mfa.sh)

