import boto3
from datetime import datetime, timezone, timedelta

def handler(event, context):
    timezone_kst = timezone(timedelta(hours=9))
    now = datetime.now(timezone_kst)
    month = ('0' + str(now.month))[-2:]
    day = ('0' + str(now.day))[-2:]
    hour = ('0' + str(now.hour))[-2:]
    minute = ('0' + str(now.minute))[-2:]
    second = ('0' + str(now.second))[-2:]
    
    region = event['region']
    bucket_name = event['bucket']
    object_body = event['text']
    
    object_key = f'{now.year}{month}{day}_{hour}{minute}{second}_log.txt'
    
    s3 = boto3.client('s3')
    s3.create_bucket(
        Bucket=bucket_name,
        CreateBucketConfiguration={'LocationConstraint': region}
    )
    s3.put_object(
        Bucket=bucket_name,
        Key=object_key,
        Body=object_body
    )

    return {
        'statusCode': 200,
        'body': f'S3 Bucket and Object Created at {now}'
    }
