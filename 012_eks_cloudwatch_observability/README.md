
Node
```
fields @timestamp, log, pod, container, node, namespace
| filter node = "ip-10-0-3-6.ec2.internal"
| sort @timestamp desc
```

Container
```
fields @timestamp, log, pod, container, node, namespace
| filter container = "aws-node"
| sort @timestamp desc
```