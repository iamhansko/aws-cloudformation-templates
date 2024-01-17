#!/bin/bash

echo -e "\033[33mALB DNS 주소를 입력해주세요.(~.com으로 끝나야 함)\033[0m"
read alb_dns

echo -e "\033[33mStable EC2 중 하나를 골라 프라이빗 IP 주소를 입력해주세요.\033[0m"
read ec2_ip

sudo yum install -y jq
echo -e "\n"

echo -e "\033[32m"22222 포트가 표시되는지 확인하겠습니다."\033[0m"
sudo netstat -lnp grep sshd

echo -e "\n"

echo -e "\033[32m"health:UP이 표시되는지 확인하겠습니다."\033[0m"
curl "http://${alb_dns}/health"

echo -e "\n"

echo -e "\033[32m"name:egg가 표시되는지 확인하겠습니다."\033[0m" 
curl "http://${alb_dns}/product" | jq .product[7]

echo -e "\n"

echo -e "\033[32m"name:smartphone이 표시되는지 확인하겠습니다."\033[0m"
curl "http://${alb_dns}/product?test=true" | jq .product[7]

echo -e "\n"

echo -e "\033[32m"404가 표시되는지 확인하겠습니다."\033[0m"
curl -w "\n%{http_code}\n" --silent "http://${alb_dns}/swagger-ui.html"

echo -e "\n"

echo -e "\033[32m"web.ws.local 접속 시 health:UP이 표시되는지 확인하겠습니다."\033[0m"
curl http://web.ws.local/health

echo -e "\n"

echo -e "\033[32m"Welcome이 뜨는지 확인하겠습니다."\033[0m"
curl "http://${ec2_ip}/swagger-ui.html"