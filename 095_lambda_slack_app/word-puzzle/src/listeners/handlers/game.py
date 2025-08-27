import random
import csv

def handler(say):
  f = open("data/movies.csv", "r", encoding="utf-8")
  csv_reader = csv.DictReader(f)
  movies = list(csv_reader)
  random_movie = random.choice(movies)

  quiz = say(f"문제 : {random_movie["quiz"]}")
  say(f"정답 : {random_movie["title"]}", thread_ts=quiz["ts"])
  
  f.close()