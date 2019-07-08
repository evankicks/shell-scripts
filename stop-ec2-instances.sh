#/bin/bash


echo ================================...checking if jq installed on the machine...=================================
brew list | grep jq



if [ $? -eq 0 ]; then echo "jq installed"
else brew install jq
fi



echo -n "enter the tag_value: "
read tag_value

echo -n "enter aws_profile: "
read aws_profile


#INSTANCE_ID="$(aws ec2 describe-instances --profile $aws_profile | jq -r --arg tag_value "$tag_value" '.Reservations[].Instances[] | select(any(.Tags[]; .Key == "action" and .Value == $tag_value)?) | .InstanceId')"  

INSTANCE_ID="$(aws ec2 describe-instances | jq -r --arg tag_value "$tag_value" '.Reservations[].Instances[] | select(any(.Tags[]; .Key == "action" and .Value == $tag_value)?) | .InstanceId')"

echo "Instances that will be stopped"

echo "*************************************************************************************"


echo $INSTANCE_ID



echo "*************************************************************************************"

aws ec2 stop-instances --instance-ids $INSTANCE_ID



