# Computing
EKS 클러스터는 ControlPlane + WorkerNode(s)로 구성됩니다.
ControlPlane은 AWS 내부에서 관리합니다.
WorkerNode(s)는 사용자가 관리합니다.  
사용자가 WorkerNode(s)를 구성하는 방식은 다음 3가지가 있습니다.

- [Managed Node Group](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html)
- [Fargate](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html)
- [Auto Mode](https://docs.aws.amazon.com/eks/latest/userguide/automode.html)

# Pod 접속(curl 테스트 등)
kubectl run curl --image=curlimages/curl --restart=Never
kubectl exec -it curl -n FARGATE_PROFILE_NAMESPACE -- sh