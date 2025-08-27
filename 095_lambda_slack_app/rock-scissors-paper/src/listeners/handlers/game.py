import random

def handler(say, context, event):
  rock_scissors_papers = ["가위", "바위", "보"]
  bot_user_id = context["bot_user_id"]
  text_input = event["text"].replace(f"<@{bot_user_id}> ", "")
  random_pick = rock_scissors_papers[random.randrange(0,3)]

  if not text_input in rock_scissors_papers:
    say("잘못된 입력입니다. 가위, 바위, 보 중 하나를 입력하세요.")

  if (text_input == "가위" and random_pick == "보") or (text_input == "바위" and random_pick == "가위") or (text_input == "보" and random_pick == "바위"):
    say(f"{random_pick}, 당신의 승리")
  elif (text_input == "가위" and random_pick == "바위") or (text_input == "바위" and random_pick == "보") or (text_input == "보" and random_pick == "가위"):
    say(f"{random_pick}, 당신의 패배")
  else:
    say(f"{random_pick}, 무승부")