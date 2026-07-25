# AWS MCP Server on EKS

## After Stack Creation

- [Kiro IDE](https://kiro.dev/blog/introducing-remote-mcp/)

  `mcp.json`

  ```json
  {
    "mcpServers": {
      "eks-mcp-server-remote": {
        "url": "https://${McpServerAlb.DNSName}",
        "disabled": false
      }
    }
  }
  ```