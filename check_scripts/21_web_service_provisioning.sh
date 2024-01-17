#!/bin/bash

echo -e "\033[33mStatic S3 버킷명을 입력해주세요.(~static으로 끝나야 함)\033[0m"
read static_bucket_name

echo -e "\033[33mArtifactory S3 버킷명을 입력해주세요.(~artifactory으로 끝나야 함)\033[0m"
read artifactory_bucket_name

echo -e "\n"

echo -e "\033[32m"10.1.0.0/16이 출력되는지 확인하겠습니다."\033[0m"
aws ec2 describe-vpcs --filter Name=tag:Name,Values=wsi-vpc --query "Vpcs[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"10.1.2.0/24가 출력되는지 확인하겠습니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-public-a --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"10.1.0.0/24가 출력되는지 확인하겠습니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-private-a --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"ap-northeast-2a가 출력되는지 확인하겠습니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-public-a --query "Subnets[].AvailabilityZone"
echo -e "\n"

echo -e "\033[32m"ap-northeast-2b가 출력되는지 확인하겠습니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-private-b --query "Subnets[].AvailabilityZone"
echo -e "\n"

echo -e "\033[32m"nat-로 시작되는 문구가 출력되는지 확인하겠습니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-private-a-rt --query "RouteTables[].Routes[].NatGatewayId"
echo -e "\n"

echo -e "\033[32m"nat-로 시작되는 문구가 출력되는지 확인하겠습니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-private-b-rt --query "RouteTables[].Routes[].NatGatewayId"
echo -e "\n"

echo -e "\033[32m"igw-로 시작되는 문구가 출력되는지 확인하겠습니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-public-rt --query "RouteTables[].Routes[].GatewayId"
echo -e "\n"

echo -e "\033[32m"index.html이 출력되는지 확인하겠습니다."\033[0m"
aws s3 ls s3://$static_bucket_name
echo -e "\n"

echo -e "\033[32m"app.py가 출력되는지 확인하겠습니다."\033[0m"
aws s3 ls s3://$artifactory_bucket_name
echo -e "\n"

# ip 기록
# aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-web-api-asg --query "Reservations[].Instances[].PrivateIpAddress"

# private ec2에서
# sudo su
# export static_bucket_name="wsi-1234-hysu-web-static"
# export artifactory_bucket_name="wsi-1234-hysu-artifactory"
# mkdir /opt/tmp/
# aws s3 cp s3://$artifactory_bucket_name/app.py /opt/tmp/app-zxzc39
# ls /opt/tmp/app-zxzc39
# echo "hellow cloud" > /opt/app-yzkz-39.txt
# aws s3 cp /opt/app-yzkz-39.txt s3://$artifactory_bucket_name/

echo -e "\033[32m"i-로 시작되는 문구가 출력되는지 확인하겠습니다."\033[0m"
aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-bastion-ec2 --query 'Reservations[].Instances[].InstanceId'
echo -e "\n"

# Bastion 에서
# ip 기록
# aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-bastion-ec2 --query "Reservations[].Instances[].PublicIpAddress"
# ip 같은지 확인 (탄력적 IP)
# aws ec2 describe-addresses --query "Addresses[].PublicIp"

echo -e "\033[32m"14개의 영문+숫자로 구성된 ID가 출력되는지 확인하겠습니다."\033[0m"
aws cloudfront list-distributions --query "DistributionList.Items[].Id"
echo -e "\n"

echo -e "\033[32m"web-static.s3.ap-northeast-2.amazonaws.com이 출력되는지 확인하겠습니다."\033[0m"
aws cloudfront list-distributions --query "DistributionList.Items[].Origins.Items[]" | jq ".[].DomainName" | grep s3
echo -e "\n"

echo -e "\033[32m"elb.amazonaws.com이 출력되는지 확인하겠습니다."\033[0m"
aws cloudfront list-distributions --query "DistributionList.Items[].Origins.Items[]" | jq ".[].DomainName" | grep elb
echo -e "\n"

# ID 기록
# aws cloudfront list-distributions --query "DistributionList.Items[].Id"
# PriceClass_All 확인
# aws cloudfront get-distribution-config --id E3E6Y6KG49GPNK --query "DistributionConfig.PriceClass"

echo -e "\033[32m"internet-facing이 출력되는지 확인하겠습니다."\033[0m"
aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].Scheme"
echo -e "\n"

echo -e "\033[32m"application이 출력되는지 확인하겠습니다."\033[0m"
aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].Type"
echo -e "\n"

# DNS 기록
# aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].DNSName"
# status ok 확인
# curl http://<DNS>/health

# IP 기록
# aws ec2 describe-instances --filter Name=tag:Name,Values=wsi-web-api-asg --query "Reservations[].Instances[].PrivateIpAddress"
# 무응답 확인
# timeout 10 curl http://10.1.1.33:8080/health

echo -e "\033[32m"Healthy 조건이 만족되는지 확인하겠습니다."\033[0m"
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query "AutoScalingGroups[].Instances[].HealthStatus"
echo -e "\n"

echo -e "\033[32m"가용영역 2a, 2b가 출력되는지 확인하겠습니다."\033[0m"
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query "AutoScalingGroups[].AvailabilityZones"
echo -e "\n"

echo -e "\033[32m"2 이상의 숫자가 출력되는지 확인하겠습니다."\033[0m"
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query "AutoScalingGroups[].MinSize"
echo -e "\n"

echo -e "\033[32m"wsi-web-api-asg가 출력되는지 확인하겠습니다."\033[0m"
aws autoscaling describe-policies --auto-scaling-group-name wsi-web-api-asg --query "ScalingPolicies[].AutoScalingGroupName"
echo -e "\n"

# 7-4, 7-5 EC2 생성,종료 생략

echo -e "\033[32m"1 이상의 숫자가 출력되는지 확인하겠습니다."\033[0m"
aws logs describe-log-groups --log-group-name-prefix /aws/ec2/wsi --query "logGroups[].storedBytes"
echo -e "\n"

# DNS 기록
# aws elbv2 describe-load-balancers --names "wsi-web-api-alb" --query "LoadBalancers[].DNSName"
# curl http://<DNS>/v1/color\?name\=blue\&hash\=999wsi2021abcd
# 999wsi2021abcd 확인 (최대 3분 소요)
# aws logs tail '/aws/ec2/wsi' --since 5m | grep 999wsi2021abcd

# ID 기록
# aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names wsi-web-api-asg --query "AutoScalingGroups[].Instances[].InstanceId"
# ID 같은지 확인
# aws logs describe-log-streams --log-group-name '/aws/ec2/wsi' --query "logStreams[].logStreamName"

# 9-2, 9-3 부하 테스트 생략