#!/bin/bash
aws ec2 run-instances \
	--image-id <AMI_ID> \
	--count 1 \
	--instance-type t3.small \
	--tag-specifications 'ResourceType=instance,Tags=[{Key=wsi:deploy:group,Value=dev-api},{Key=Name,Value='$1'}]' \
	--key-name <PEM_KEY_NAME> \
	--iam-instance-profile Name=wsi-api \
	--security-group-ids <SECURITY_GROUP_ID> \
	--subnet-id <SUBNET_ID>