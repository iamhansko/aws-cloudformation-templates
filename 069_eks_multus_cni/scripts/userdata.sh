MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==BOUNDARY=="

--==BOUNDARY==
Content-Type: application/node.eks.aws; charset="us-ascii"

apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: 
    apiServerEndpoint:
    certificateAuthority:
    cidr:

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -o xtrace

subnetListAZ1="subnet1 subnet2 subnet3"
secGrpListAZ1="sg1 sg2 sg3"

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID="`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id`"
REGION=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r`
AZ="`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .availabilityZone`"

createAttachEni () {
subnet=$1
secGrp=$2
region=$3
subnetId=`aws ec2 describe-subnets --region $region --filters "Name=tag:Name,Values=$subnet" --query "Subnets[*].SubnetId" --output text`
secGrpId=`aws ec2 describe-security-groups --region $region --filters "Name=tag:Name,Values=$secGrp" --query "SecurityGroups[*].GroupId" --output text`

subnetipv6Cidr=`aws ec2 describe-subnets --region $region --subnet-ids $subnetId --query "Subnets[*].Ipv6CidrBlockAssociationSet[*].Ipv6CidrBlock" --output text`
if [ -n "$subnetipv6Cidr" ]; then
  eni=$(aws ec2 create-network-interface --region $region --subnet-id $subnetId --description "eth$((n+1))" --groups $secGrpId --ipv6-address-count 1 \
  --tag-specifications "ResourceType="network-interface",Tags=[{Key="node.k8s.amazonaws.com/no_manage",Value="true"}]" | jq -r '.NetworkInterface.NetworkInterfaceId, .NetworkInterface.PrivateIpAddresses[0].PrivateIpAddress')
else
  eni=$(aws ec2 create-network-interface --region $region --subnet-id $subnetId --description "eth$((n+1))" --groups $secGrpId \
  --tag-specifications "ResourceType="network-interface",Tags=[{Key="node.k8s.amazonaws.com/no_manage",Value="true"}]" | jq -r '.NetworkInterface.NetworkInterfaceId, .NetworkInterface.PrivateIpAddresses[0].PrivateIpAddress')
fi

eniId=`echo $eni | cut -d' ' -f 1`
attachmentId=$(aws ec2 attach-network-interface --region $region --network-interface-id $eniId --instance-id $INSTANCE_ID --device-index $((n+2)) | jq -r '.AttachmentId')
aws ec2 modify-network-interface-attribute --region $region --network-interface-id $eniId --no-source-dest-check
aws ec2 modify-network-interface-attribute --region $region --attachment "AttachmentId"="$attachmentId","DeleteOnTermination"="True" --network-interface-id $eniId
}

n=0
for subnet in $subnetListAZ1; do
secGrp=$(echo $secGrpListAZ1 | cut -d' ' -f$((n+1)))
createAttachEni "$subnet" "$secGrp" "$REGION"
n=$((n+1))
done

echo "net.ipv4.conf.default.rp_filter = 0" | tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter = 0" | tee -a /etc/sysctl.conf
sysctl -p
sed -i "s/^GRUB_CMDLINE_LINUX_DEFAULT=\"/&net.ifnames=0 biosdevname=0 /" /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

rm -f /etc/eks/nodeadm/udev-net-manager/${INSTANCE_ID}/ens*
ENI_COUNT=$(echo $subnetListAZ1 | wc -w)
for ((i = 0; i < ENI_COUNT; i++)); do
  echo "cni" > "/etc/eks/nodeadm/udev-net-manager/${INSTANCE_ID}/eth$((i + 1))"
done

reboot

--==BOUNDARY==--