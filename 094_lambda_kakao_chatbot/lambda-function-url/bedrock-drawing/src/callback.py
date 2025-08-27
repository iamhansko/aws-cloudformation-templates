import requests
import boto3
import os
from datetime import datetime
import base64
import json

TEXT_TO_IMAGE_S3_BUCKET_NAME = os.getenv('TEXT_TO_IMAGE_S3_BUCKET_NAME')
AWS_REGION_NAME = os.getenv('AWS_REGION_NAME')

def lambda_handler(event, context):
    text_input = event['text_input']
    callback_url = event['callback_url']

    # https://docs.aws.amazon.com/ko_kr/translate/latest/dg/examples-ct.html
    english_text = boto3.client('translate').translate_text(
        Text=text_input, 
        SourceLanguageCode='ko', 
        TargetLanguageCode='en'
    )['TranslatedText']

    # https://docs.aws.amazon.com/ko_kr/bedrock/latest/userguide/bedrock-runtime_example_bedrock-runtime_InvokeModel_StableDiffusion_section.html
    response = boto3.client('bedrock-runtime').invoke_model(
        modelId='stability.sd3-large-v1:0',
        # https://docs.aws.amazon.com/ko_kr/bedrock/latest/userguide/model-parameters-diffusion-3-text-image.html
        body=json.dumps({
        'prompt': english_text,
        'negative_prompt': '(worst quality), (low quality:1.3), (text:1.8), (logo:1.8), (nsfw), low resolution, deformed, blurred, bad anatomy, disfigured, badly drawn face, mutation, mutated, extra limb, missing limb, blurred, floating limbs, detached limbs, blurred, watermark, bad proportion, cropped image'
        })
    )
    image_data = base64.b64decode(json.loads(response['body'].read().decode('utf-8'))['images'][0])
    image_path = os.path.join('/tmp', 'stability.png')
    with open(image_path, 'wb') as file:
        file.write(image_data)

    image_name = f'{datetime.now().strftime('%Y%m%d%H%M%S')}.png'
    boto3.client('s3').upload_file(image_path, TEXT_TO_IMAGE_S3_BUCKET_NAME, image_name)
    image_url = f'https://{TEXT_TO_IMAGE_S3_BUCKET_NAME}.s3.{AWS_REGION_NAME}.amazonaws.com/{image_name}'

    # https://kakaobusiness.gitbook.io/main/tool/chatbot/skill_guide/ai_chatbot_callback_guide#skillresponse
    requests.post(callback_url, json={
        'version': '2.0',
        'useCallback': False,
        'template': { 'outputs': [ { 'simpleImage': { 'imageUrl': image_url, 'altText' : 'text-to-image' } } ] }
    })

    os.remove(image_path)
    return True