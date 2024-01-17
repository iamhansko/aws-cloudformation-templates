#!/bin/bash

echo -e "\033[33mStatic AWS 계정 ID를 입력해주세요.(12자리 숫자)\033[0m"
read account_id

echo -e "\n"

docker ps -a | grep -v CONTAINER | awk '{print "docker stop " $1}' | sh -x
docker ps -a | grep -v CONTAINER | awk '{print "docker rm " $1}' | sh -x
# docker images | grep -v IMAGE | awk '{print "docker rmi " $3}' | sh -x
docker system prune -af

echo -e "\033[32m"AWS ECR에 로그인합니다."\033[0m"
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin $account_id.dkr.ecr.ap-northeast-2.amazonaws.com
echo -e "\n"

echo -e "\033[32m"이미지를 다운로드합니다."\033[0m"
docker pull $account_id.dkr.ecr.ap-northeast-2.amazonaws.com/day3:latest
echo -e "\n"

echo -e "\033[32m"컨테이너를 실행합니다."\033[0m"
docker run -d -p 18888:8080 $account_id.dkr.ecr.ap-northeast-2.amazonaws.com/day3:latest
echo -e "\n"

echo -e "\033[32m"실행한 컨테이너가 구동되었는지 확인합니다."\033[0m"
docker ps
echo -e "\n"

echo -e "\033[32m"컨테이너 서버로 HTTP request를 호출합니다."\033[0m"
sleep 5
curl http://localhost:18888/health
echo -e "\n"

container_id=$(docker ps | grep 'day3:latest' | awk '{print $1}')

echo -e "\033[32m"컨테이너에 접속하여 결과값에 NAME='Alpine Linux'가 포함되어 있는지 확인합니다."\033[0m"
docker exec -it $container_id cat /etc/os-release
echo -e "\n"

echo -e "\033[32m"컨테이너에 접속하여 Python 3.7x의 버전을 가지는지 확인합니다."\033[0m"
docker exec -it $container_id python3 -V
echo -e "\n"

echo -e "\033[32m"LISTEN 상태의 8080포트를 가지고 있는지 확인합니다."\033[0m"
docker exec -it $container_id netstat -an | grep 8080
echo -e "\n"