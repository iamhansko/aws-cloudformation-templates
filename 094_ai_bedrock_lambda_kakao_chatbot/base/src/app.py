import json
import os
import boto3

CALLBACK_LAMBDA_FUNCTION_NAME = os.getenv('CALLBACK_LAMBDA_FUNCTION_NAME')

def lambda_handler(event, context):  
    request_body = json.loads(event['body'])
    
    boto3.client('lambda').invoke(
        FunctionName=CALLBACK_LAMBDA_FUNCTION_NAME,
        InvocationType='Event',
        Payload=json.dumps({
            'text_input' : request_body['userRequest']['utterance'],
            'callback_url' : request_body['userRequest']['callbackUrl']
        })
    )

    return {
        'statusCode':200,
        'body': json.dumps({
            'version': '2.0',
            'useCallback' : True,
            'data': { 'text' : '답변 생성 중입니다. 잠시 기다려주세요.' }
        })
    }