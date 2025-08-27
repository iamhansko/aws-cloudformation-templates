# Basic Lambda Slack App
<br/>

# Used
- [Python](https://www.python.org/downloads/)
- [Slack Bolt for Python](https://github.com/slackapi/bolt-python)
- [AWS CLI](https://aws.amazon.com/ko/cli/)
- [AWS SAMCLI](https://docs.aws.amazon.com/ko_kr/serverless-application-model/latest/developerguide/install-sam-cli.html#install-sam-cli-instructions)

<br/>

# Project Structure
```
📦aws-cost-explorer-slack-app
 ┣ 📂src
 ┃ ┣ 📂listeners
 ┃ ┃ ┣ 📂handlers
 ┃ ┃ ┃ ┗ 📜game.py
 ┃ ┃ ┗ 📜events.py
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
# mkdir -p layer/python
# pip install slack_bolt -t ./layer/python
# Zip layer/ -> layer.zip

slack_bolt
```