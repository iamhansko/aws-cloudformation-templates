# Lambda MCP Server

## Deployment
```
# Deploy
sam deploy -t q_cli.yaml

# Clean Up
sam delete --no-prompts
```

## Notes
CloudFormation 스택 생성 후, VsCode on EC2 접속
```
q chat --trust-all-tools
# MCP 서버 로딩 실패 시, "`/exit`" 후 "`q chat --trust-all-tools`" 재시도
```

## References
- [MCP - Can Lambda do it?](https://www.youtube.com/watch?v=Ejua5LQTqek)
- [MCP Workshop](https://catalog.workshops.aws/mcp-tutorial-on-aws/ko-KR/00-getting-started)