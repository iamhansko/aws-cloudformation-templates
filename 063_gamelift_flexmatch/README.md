# Gamelift Flexmatch

## Notes
game-rank-update - event['Records']
```
{
  'eventID': '6dc1988b2fff89683c8bf2e93222be27', 
  'eventName': 'MODIFY', 
  'eventVersion': '1.1', 
  'eventSource': 'aws:dynamodb', 
  'awsRegion': 'us-east-1', 
  'dynamodb': {
    'ApproximateCreationDateTime': 1759554431.0, 
    'Keys': {'PlayerName': {'S': 'SomeName'}}, 
    'NewImage': {
      'Lose': {'N': '0'}, 
      'Score': {'N': '1200'}, 
      'PlayerName': {'S': 'SomeName'}, 
      'Win': {'N': '2'}}, 
      'OldImage': {
        'Lose': {'N': '0'}, 
        'Score': {'N': '1100'}, 
        'PlayerName': {'S': 'SomeName'}, 
        'Win': {'N': '1'}
      }, 
      'SequenceNumber': '3464200001930852085989368', 
      'SizeBytes': 88, 
      'StreamViewType': 'NEW_AND_OLD_IMAGES'
  }, 
  'eventSourceARN': 'arn:aws:dynamodb:us-east-1:123456789012:table/GomokuPlayerInfo/stream/2025-01-01T00:00:00.000'
}
```

## References
- [AWS Samples](https://aws-samples.github.io/aws-gamelift-sample/ko/)