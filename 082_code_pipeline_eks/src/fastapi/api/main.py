from fastapi import FastAPI
import os

USERNAME = os.environ.get("USERNAME", "David")

app = FastAPI()

@app.get("/hello")
async def get_hello():
  return {"message": f"Hello {USERNAME}"}

@app.get("/health")
async def get_health():
  return {"message": "Healthy"}