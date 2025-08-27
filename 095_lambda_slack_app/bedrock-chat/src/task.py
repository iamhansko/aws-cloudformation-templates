import os
from langchain_aws import ChatBedrock

def handler(text_input):
  # https://python.langchain.com/docs/integrations/llms/bedrock/
  bedrock_llm = ChatBedrock(
    credentials_profile_name='default',
    model_id='anthropic.claude-3-5-sonnet-20240620-v1:0'
  )
  text_output = bedrock_llm.invoke([("human", text_input)]).content
  
  return text_output
