```bash
kubectl get events -n kube-system | grep aws-load-balancer-controller

# Warning FailedCreate replicaset/aws-load-balancer-controller-5c96f57fd5 Error creating: pods "aws-load-balancer-controller-5c96f57fd5-" is forbidden: error looking up service account kube-system/aws-load-balancer-controller: serviceaccount "aws-load-balancer-controller" not found

eksctl create iamserviceaccount \
  --cluster=stem-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  # Edit Following IAM Policy ARN
  --attach-policy-arn=arn:aws:iam::012345678912:policy/AWSLoadbalancerControllerIamPolicy \
  --approve --region ap-northeast-2

# Error: unable to create iamserviceaccount(s) without IAM OIDC provider enabled
# Edit Following Cluster Name
# eksctl utils associate-iam-oidc-provider --region=ap-northeast-2 --cluster=CLUSTER_NAME --approve
# kubectl get serviceaccount -n kube-system aws-load-balancer-controller
# kubectl rollout restart -n kube-system deploy aws-load-balancer-controller

```