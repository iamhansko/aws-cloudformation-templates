# 🧠 Base

## Deployment
```
cd base

# 1st Deployment
sam build & sam deploy --guided --capabilities CAPABILITY_NAMED_IAM

# Update
sam build & sam deploy --no-confirm-changeset --no-disable-rollback --capabilities CAPABILITY_NAMED_IAM
```

## Packages
```
# cd base
# https://docs.aws.amazon.com/ko_kr/lambda/latest/dg/python-layers.html#python-layer-manylinux
# pip install --platform=manylinux2014_x86_64 --only-binary=:all: boto3 requests -t ./layer/python
# layer/ -> layer.zip

boto3
requests
```

## 카카오 비즈니스 챗봇 관리자센터
```
헤더값 입력
x-api-key : YOUR_API_GATEWAY_API_KEY
```
