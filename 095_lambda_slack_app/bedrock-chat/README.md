# Bedrock Chat Lambda Slack App
<br/>

# Used
- [Python](https://www.python.org/downloads/)
- [Slack Bolt for Python](https://github.com/slackapi/bolt-python)
- [AWS CLI](https://aws.amazon.com/ko/cli/)
- [AWS SAMCLI](https://docs.aws.amazon.com/ko_kr/serverless-application-model/latest/developerguide/install-sam-cli.html#install-sam-cli-instructions)

<br/>

# Project Structure
```
📦bedrock-chat
 ┣ 📂src
 ┃ ┣ 📜event.py
 ┃ ┗ 📜app.py
 ┣ 📜layer.zip
 ┣ 📜template.yaml
 ┣ 📜README.md
 ┗ 📜.gitignore
```

# Deployment
```
# 1st Deployment
sam build & sam deploy --guided --capabilities CAPABILITY_NAMED_IAM

# Update
sam build & sam deploy --no-confirm-changeset --no-disable-rollback --capabilities CAPABILITY_NAMED_IAM
```

# Packages
```
mkdir -p layer/python
# https://docs.aws.amazon.com/ko_kr/lambda/latest/dg/python-layers.html#python-layer-manylinux
pip install --platform=manylinux2014_x86_64 --only-binary=:all: boto3 langchain_aws slack_bolt -t ./layer/python
# Zip layer/ -> layer.zip

boto3 
langchain_aws
slack_bolt

```
