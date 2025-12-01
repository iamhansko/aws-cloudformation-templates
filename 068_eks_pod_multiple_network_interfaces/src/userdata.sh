Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -o xtrace

instanceId=$(ec2-metadata -i --quiet)
subnetId=$(aws ec2 describe-instances --instance-ids $instanceId --query 'Reservations[0].Instances[0].SubnetId' --output text)
secGrpId=$(aws ec2 describe-instances --instance-ids $instanceId --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' --output text)

ens6=$(aws ec2 create-network-interface --subnet-id $subnetId \
--description "VRF1" --groups $secGrpId \
--tag-specifications "ResourceType="network-interface",\
Tags=[{Key="node.k8s.amazonaws.com/no_manage",Value="true"}]" | jq -r '.NetworkInterface.NetworkInterfaceId');

ens7=$(aws ec2 create-network-interface --subnet-id $subnetId \
--description "VRF2" --groups $secGrpId \
--tag-specifications "ResourceType="network-interface",\
Tags=[{Key="node.k8s.amazonaws.com/no_manage",Value="true"}]" | jq -r '.NetworkInterface.NetworkInterfaceId');

attachmentResult1=$(aws ec2 attach-network-interface --network-interface-id $ens6 \
--instance-id $instanceId \
--output text --device-index 1)

attachmentResult2=$(aws ec2 attach-network-interface --network-interface-id $ens7 \
--instance-id $instanceId \
--output text --device-index 2)

attachment1Id=$(echo "$attachmentResult1" | awk '{print $1}')
aws ec2 modify-network-interface-attribute --network-interface-id $ens6 --no-source-dest-check
aws ec2 modify-network-interface-attribute --attachment AttachmentId=$attachment1Id,DeleteOnTermination=True --network-interface-id $ens6

attachment2Id=$(echo "$attachmentResult2" | awk '{print $1}')
aws ec2 modify-network-interface-attribute --network-interface-id $ens7 --no-source-dest-check
aws ec2 modify-network-interface-attribute --attachment AttachmentId=$attachment2Id,DeleteOnTermination=True --network-interface-id $ens7

--==BOUNDARY==--