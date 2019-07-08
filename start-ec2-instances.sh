#/bin/bash


echo ================================...checking if jq installed on the machine...=================================
brew list | grep jq



if [ $? -eq 0 ]; then echo "jq installed"
else brew install jq
fi


#ENTER THE TAG VALUE FOR THE INSTANCES THAT NEED TO BE STOPPED
echo -n "enter the tag_value: "
read tag_value



echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_SESSION_TOKEN
echo $AWS_DEFAULT_REGION


# dont pass --profile for the below command, it'll override the environment variable set by mfa-prod.sh

INSTANCE_ID="$(aws ec2 describe-instances | jq -r --arg tag_value "$tag_value" '.Reservations[].Instances[] | select(any(.Tags[]; .Key == "action" and .Value == $tag_value)?) | .InstanceId')"


echo "Instances that will be started"

echo "*************************************************************************************"


echo $INSTANCE_ID



echo "*************************************************************************************"

aws ec2 start-instances --instance-ids $INSTANCE_ID
