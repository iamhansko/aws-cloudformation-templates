import requests

def handler(say):
  url = "https://dksh.awskorea.kr"
  response = requests.get(url)
  data = response.json()

  say(
    # https://app.slack.com/block-kit-builder#%7B%22blocks%22:%5B%7B%22type%22:%22section%22,%22text%22:%7B%22type%22:%22mrkdwn%22,%22text%22:%22tasty%20(%3Chttps://assets3.thrillist.com/v1/image/1682388/size/tl-horizontal_main.jpg%7C%EC%9D%B4%EB%AF%B8%EC%A7%80%3E)%22%7D%7D%5D%7D
    blocks = [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": f"{data["menu"]} (<{data["image"]}|이미지>)"
        }
      }
    ]
  )