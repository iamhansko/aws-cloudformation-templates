import hgtk
import random

def handler(say, event, context):
  bot_user_id = context["bot_user_id"]
  text_input = event["text"].replace(f"<@{bot_user_id}> ", "")
  text_transform = hgtk.text.decompose(text_input).replace('ㅏ', 'ㅡ').replace('ㅜ', 'ㅡ')
  text_output = hgtk.text.compose(text_transform)

  prefix = ""
  postfix = ""
  if random.randrange(0,10) > 2:
    postfix = "~"
  if random.randrange(0,10) > 2:
    prefix = "에베베베베 "
  
  say(f"{prefix}{text_output}{postfix}")