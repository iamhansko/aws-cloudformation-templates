# EKS Networking Troubleshooting

## Notes

API Server Endpoint
```
curl -k -H "Authorization: Bearer $(aws eks get-token --output json --cluster-name EksCluster-bOqELSeBIOUa | jq -r .status.token)" \
-H "Accept: application/json;g=apidiscovery.k8s.io;v=v2;as=APIGroupDiscoveryList" \
$(aws eks describe-cluster --output json --name EksCluster-bOqELSeBIOUa | jq -r .cluster.endpoint)/apis | jq .

kubectl get --raw /apis | jq .

curl -k -H "Authorization: Bearer $(aws eks get-token --output json --cluster-name EksCluster-bOqELSeBIOUa | jq -r .status.token)" \
-H "Accept: application/json" \
$(aws eks describe-cluster --output json --name EksCluster-bOqELSeBIOUa | jq -r .cluster.endpoint)/api/v1/nodes | jq .

kubectl get --raw /api/v1/nodes | jq .
```

## References
- [EKS Pod Status Troubleshooting](https://repost.aws/ko/knowledge-center/eks-pod-status-troubleshooting)
- [Addressing-IPv4 Address Exhaustion](https://aws.amazon.com/ko/blogs/containers/addressing-ipv4-address-exhaustion-in-amazon-eks-clusters-using-private-nat-gateways/)