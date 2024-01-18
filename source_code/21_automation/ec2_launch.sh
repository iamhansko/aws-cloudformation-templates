#!/bin/bash
aws ec2 run-instances \
	--image-id <AMI_ID> \
	--count 1 \
	--instance-type t3.small \
	--tag-specifications 'ResourceType=instance,Tags=[{Key=wsi:deploy:group,Value=dev-api},{Key=Name,Value='$1'}]' \
	--key-name <PEM_KEY_NAME> \
	--iam-instance-profile Name=wsi-api \
	--security-group-ids <SECURITY_GROUP_ID> \
	--subnet-id <SUBNET_ID> \
	--user-data '#!/bin/bash -xe
	exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
	dnf update -y
	dnf install ruby wget -y
	wget https://aws-codedeploy-<AWS_REGIN>.s3.<AWS_REGION>.amazonaws.com/latest/install
	chmod +x ./install
	./install auto
	service codedeploy-agent status'