import requests
import json
import boto3

# https://python.langchain.com/docs/integrations/llms/bedrock/
def bedrock_chatbot(text):
    response = boto3.client('bedrock-runtime').invoke_model(
        modelId = 'anthropic.claude-3-5-sonnet-20240620-v1:0', 
        body = json.dumps({
            'anthropic_version': 'bedrock-2023-05-31',
            'messages': [ { 'role': 'user', 'content': text } ],
            'max_tokens': 2048,
            'temperature': 0.5
        }),
        accept='application/json', 
        contentType='application/json'
    )
    return json.loads(response.get('body').read())['content'][0]['text']

def lambda_handler(event, context):
    text_input = event['text_input']
    callback_url = event['callback_url']

    result = bedrock_chatbot(text_input)

    # https://kakaobusiness.gitbook.io/main/tool/chatbot/skill_guide/ai_chatbot_callback_guide#skillresponse
    requests.post(callback_url, json={
        'version': '2.0',
        'useCallback': False,
        'template': { 'outputs': [ { 'simpleText': { 'text': f'{result}' } } ] }
    })

    return True