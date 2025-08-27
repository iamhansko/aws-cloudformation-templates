import random
import csv

def handler(say):
  f = open("data/countries.csv", "r", encoding="utf-8-sig")
  csv_reader = csv.DictReader(f)
  countries = list(csv_reader)
  random_country = random.choice(countries)

  quiz = say(
    blocks=[
      {
        "type": "image",
        "image_url": f"https://awskorea-flag-images.s3.ap-northeast-2.amazonaws.com/{random_country['code']}.gif",
        "alt_text": f"{random_country['code']}"
      }
    ]
  )
  say(f"정답 : {random_country['korean']}({random_country['english']})", thread_ts=quiz["ts"])
  
  f.close()