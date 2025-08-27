import base64
import boto3
import json
import os
import random
from datetime import datetime

TEXT_TO_IMAGE_S3_BUCKET_NAME = os.getenv("TEXT_TO_IMAGE_S3_BUCKET_NAME")

def handler(text_input):
  # https://docs.aws.amazon.com/ko_kr/translate/latest/dg/examples-ct.html
  translate = boto3.client(service_name='translate')
  english_text = translate.translate_text(
     Text=text_input, 
     SourceLanguageCode="ko", 
     TargetLanguageCode="en"
  )["TranslatedText"]

  # https://docs.aws.amazon.com/ko_kr/bedrock/latest/userguide/bedrock-runtime_example_bedrock-runtime_InvokeModel_StableDiffusion_section.html
  bedrock = boto3.client("bedrock-runtime")
  seed = random.randint(0, 4294967295)
  response = bedrock.invoke_model(
    modelId="stability.stable-diffusion-xl-v1",
    # https://docs.aws.amazon.com/ko_kr/bedrock/latest/userguide/model-parameters-diffusion-1-0-text-image.html 
    body=json.dumps({
      "text_prompts": [{"text": english_text}],
      "style_preset": "photographic",
      "seed": seed,
      "cfg_scale": 15,
      "steps": 50,
    })
  )
  model_response = json.loads(response["body"].read())
  base64_image_data = model_response["artifacts"][0]["base64"]
  image_data = base64.b64decode(base64_image_data)
  image_path = os.path.join("/tmp", "stability.png")
  with open(image_path, "wb") as file:
      file.write(image_data)

  s3 = boto3.client('s3')
  now = datetime.now().strftime("%Y%m%d%H%M%S")
  image_name = f'{now}_{seed}.png'
  s3.upload_file(image_path, TEXT_TO_IMAGE_S3_BUCKET_NAME, image_name)

  os.remove(image_path)
  
  return image_name
