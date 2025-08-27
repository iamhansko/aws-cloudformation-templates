import os
import sys
from slack_bolt import App 
from slack_bolt.oauth.oauth_settings import OAuthSettings
from slack_bolt.adapter.aws_lambda import SlackRequestHandler
from slack_bolt.adapter.aws_lambda.lambda_s3_oauth_flow import LambdaS3OAuthFlow
sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
import task

SLACK_CLIENT_ID = os.getenv("SLACK_CLIENT_ID")
SLACK_CLIENT_SECRET = os.getenv("SLACK_CLIENT_SECRET")
SLACK_SIGNING_SECRET = os.getenv("SLACK_SIGNING_SECRET")
OAUTH_STATE_S3_BUCKET_NAME = os.getenv("OAUTH_STATE_S3_BUCKET_NAME")
INSTALLATION_S3_BUCKET_NAME = os.getenv("INSTALLATION_S3_BUCKET_NAME")
TEXT_TO_IMAGE_S3_BUCKET_NAME = os.getenv("TEXT_TO_IMAGE_S3_BUCKET_NAME")
AWS_REGION_NAME = os.getenv("AWS_REGION_NAME")

app = App(
    process_before_response = True,
    raise_error_for_unhandled_request=True,
    signing_secret = SLACK_SIGNING_SECRET,
    oauth_flow = LambdaS3OAuthFlow(
        settings=OAuthSettings(
            client_id = SLACK_CLIENT_ID,
            client_secret = SLACK_CLIENT_SECRET,
            scopes = [
                'chat:write',
                'app_mentions:read',
                'channels:join',
                'channels:history',
                'groups:history',
                'mpim:history',
                'im:history'
            ],
        ),
        oauth_state_bucket_name = OAUTH_STATE_S3_BUCKET_NAME,
        installation_bucket_name = INSTALLATION_S3_BUCKET_NAME,
    ),
)

@app.event("app_mention")
def handle_app_mention(say, event, client, context):
    channel = event["channel"]
    thread = event["ts"]
    bot_user_id = context["bot_user_id"]
    text_input = event["text"].replace(f"<@{bot_user_id}> ", "")
    
    response = task.handler(text_input)

    messages = (client.conversations_replies(channel=channel, ts=thread))["messages"]
    if not (len(messages)>1 and any(message["user"]==bot_user_id for message in messages)):
        # say("Please Wait", thread_ts=thread)
        # response = task.handler(text_input)
        say(blocks=[
            {
                "type": "image",
                "image_url": f"https://{TEXT_TO_IMAGE_S3_BUCKET_NAME}.s3.{AWS_REGION_NAME}.amazonaws.com/{response}",
                "alt_text": f"{response}"
            }
        ], thread_ts=thread)

def lambda_handler(event, context):
    slack_handler = SlackRequestHandler(app=app)
    return slack_handler.handle(event, context)