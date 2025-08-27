import requests
import time

def lambda_handler(event, context):
    text_input = event['text_input']
    callback_url = event['callback_url']

    time.sleep(5)

    # https://kakaobusiness.gitbook.io/main/tool/chatbot/skill_guide/ai_chatbot_callback_guide#skillresponse
    requests.post(callback_url, json={
        'version': '2.0',
        'useCallback': False,
        'template': { 'outputs': [ { 'simpleText': { 'text': f'{text_input}' } } ] }
    })

    return True