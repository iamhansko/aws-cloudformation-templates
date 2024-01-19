#!/bin/bash

# echo -e "\033[33mLoad Balancer 이름을 입력해주세요.(12자리 숫자)\033[0m"
# read lb_name

# echo -e "\033[33mTarget Group 이름을 입력해주세요.(12자리 숫자)\033[0m"
# read tg_name

# echo -e "\n"

echo -e "\033[32m"10.1.0.0/16이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-vpcs --filter Name=tag:Name,Values=wsi-vpc --query "Vpcs[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"10.1.2.0/24이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-public-a --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"10.1.0.0/24이 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-private-a --query "Subnets[].CidrBlock"
echo -e "\n"

echo -e "\033[32m"ap-northeast-2a가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-public-a --query "Subnets[].AvailabilityZone"
echo -e "\n"

echo -e "\033[32m"ap-northeast-2b가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-subnets --filter Name=tag:Name,Values=wsi-private-b --query "Subnets[].AvailabilityZone"
echo -e "\n"

echo -e "\033[32m"nat-으로 시작하는 문구가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-private-a-rt --query "RouteTables[].Routes[].NatGatewayId"
echo -e "\n"

echo -e "\033[32m"nat-으로 시작하는 문구가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-private-b-rt --query "RouteTables[].Routes[].NatGatewayId"
echo -e "\n"

echo -e "\033[32m"igw-으로 시작하는 문구가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-route-tables --filter Name=tag:Name,Values=wsi-public-rt --query "RouteTables[].Routes[].GatewayId"
echo -e "\n"

echo -e "\033[32m"wsi-api-1, wsi-api-2가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-instances --filters "Name=tag:wsi:deploy:group,Values=dev-api" --query "Reservations[].Instances[].Tags[]" | jq '.[] | select ( .Key == "Name" ) .Value'
echo -e "\n"

echo -e "\033[32m"arn:aws:iam::XXXXXXXXXXXX:instance-profile/wsi-api가 출력되는지 확인합니다."\033[0m"
aws ec2 describe-instances --filters "Name=tag:Name,Values=wsi-api-1" --query "Reservations[].Instances[].IamInstanceProfile[].Arn"
echo -e "\n"

# echo -e "\033[32m"application이 출력되는지 확인합니다."\033[0m"
# aws elbv2 describe-load-balancers —names $lb_name --query "LoadBalancers[].Type"
# echo -e "\n"

# tg_arn=$(aws elbv2 describe-target-groups —names $tg_name --query "TargetGroups[].TargetGroupArn")

# echo -e "\033[32m"healthy라고 표기되는 EC2 2대가 있는지 확인합니다."\033[0m"
# aws elbv2 describe-target-health --query "TargetHealthDescriptions[].TargetHealth.State" --target-group-arn $tg_arn
# echo -e "\n"

# lb_dns=$(aws elbv2 describe-load-balancers --names "wsi-api-alb" --query "LoadBalancers[].DNSName")

# echo -e "\033[32m"{'status':'ok'}가 나오는지 확인합니다."\033[0m"
# curl http://$lb_dns/health
# echo -e "\n"

echo -e "\033[32m"wsi-api가 출력되는지 확인합니다."\033[0m"
aws deploy get-application --application-name wsi-api --query "application.applicationName"
echo -e "\n"

echo -e "\033[32m"IN_PLACE가 출력되는지 확인합니다."\033[0m"
aws deploy get-deployment-group --application-name wsi-api --deployment-group-name dev-api --query "deploymentGroupInfo.deploymentStyle.deploymentType"
echo -e "\n"

echo -e "\033[32m"출력 결과에 wsi:deploy:group, dev-api가 포함되어 있는지 확인합니다."\033[0m"
aws deploy get-deployment-group --application-name wsi-api --deployment-group-name dev-api --query "deploymentGroupInfo.ec2TagSet.ec2TagSetList[]"
echo -e "\n"

echo -e "\033[32m"출력 결과 중 wsi-api-pipeline이 있는지 확인합니다."\033[0m"
aws codepipeline list-pipelines --query "pipelines[].name"
echo -e "\n"

/opt/ec2_launch.sh wsi-api-9847 > /dev/null 2> /dev/null

echo -e "\033[32m"ec2_launch.sh로 EC2를 생성하고 30초 대기합니다."\033[0m"
sleep 10
echo -e "\033[32m"10초"\033[0m"
sleep 10
echo -e "\033[32m"20초"\033[0m"
sleep 10
echo -e "\033[32m"30초"\033[0m"
echo -e "\n"

echo -e "\033[32m"wsi-api-9847 EC2가 생성되었는지 확인합니다. 출력 결과에 wsi:deploy:group, dev-api가 포함되어 있는지 확인합니다."\033[0m"
aws ec2 describe-instances --filters "Name=tag:Name,Values=wsi-api-9847" --query "Reservations[].Instances[].Tags[]"
echo -e "\n"

# new_lb_dns=$(aws elbv2 describe-load-balancers --names "wsi-api-alb" --query "LoadBalancers[].DNSName")

# echo -e "\033[32m"{'hash': 'wsi-ffad-9642', 'code': 200}가 나오는지 확인합니다."\033[0m"
# curl http://$new_lb_dns/health
# echo -e "\n"

# instance_ip=$(echo $(aws ec2 describe-instances --filters "Name=tag:Name,Values=wsi-api-9847" --query "Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddress") | cut -d '"' -f2 )

# ssh ec2-user@$instance_ip

# echo -e "\033[32m"{'hash': 'wsi-ffad-9642', 'code': 200}가 나오는지 확인합니다."\033[0m"
# curl http://$instance_ip:80/health
# echo -e "\n"

# instance_id=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=wsi-api-9847" --query "Reservations[].Instances[].InstanceId")

# new_tg_arn=$(aws elbv2 describe-target-groups --names wsi-api-tg --query "TargetGroups[].TargetGroupArn")

# echo -e "\033[32m"출력 결과에 $instance_id가 포함되어 있는지 확인합니다."\033[0m"
# aws elbv2 describe-target-health --target-group-arn $new_tg_arn --query "TargetHealthDescriptions[].Target.Id"
# echo -e "\n"

echo -e "\033[32m"wsi-api-ecr을 출력하는지 확인합니다."\033[0m"
aws ecr describe-repositories --repository-name wsi-api-ecr --query "repositories[].repositoryName"
echo -e "\n"

# echo -e "\033[32m"출력 결과 중 현재 시간으로 Tag가 설정된 이미지가 있는지 확인합니다."\033[0m"
# aws ecr list-images --repository-name wsi-api-ecr --query "imageIds[].imageTag"
# echo -e "\n"

# image_url=$(aws ecr describe-repositories --repository-name wsi-api-ecr --query "repositories[].repositoryUri")

# image_tag=$(aws ecr list-images --repository-name wsi-api-ecr --query "imageIds[].imageTag")

# aws ecr get-login --no-include-email | sh -x

# docker pull $image_url:$image_tag

# docker run -d -p 28888:80/tcp $image_url:$image_tag

# echo -e "\033[32m"{'code':200,'hash':'wsi-release-ffaa'}를 출력하는지 확인합니다."\033[0m"
# curl http://localhost:28888/health
# echo -e "\n"