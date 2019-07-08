!/bin/bash
region=$1
volume=$2
size=$3
aws ec2 modify-volume --region $region --volume-id $volume --size $size
volumeStatus=""
while [[ $volumeStatus != "completed" ]]
do
  sleep 5
  volumeStatus=$(aws ec2 describe-volumes-modifications --region $region --volume-id $volume | jq .VolumesModifications[].ModificationState)
  volumeStatus=${volumeStatus//\"/}
  echo $volumeStatus
done
