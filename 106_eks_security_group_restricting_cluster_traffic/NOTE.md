Error from server (InternalError): error when creating "manifests/g.yaml": Internal error occurred: failed calling webhook "vingress.elbv2.k8s.aws": failed to call webhook: Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1-ingress?timeout=10s": context deadline exceeded

docker pull 635645195625.dkr.ecr.ap-northeast-2.amazonaws.com/nginx:latest
latest: Pulling from nginx
b21337b36fa4: Retrying in 1 second 
46bf3a120c8e: Retrying in 1 second 
4f4efe02d542: Retrying in 1 second 
7b6cb8ccac7b: Waiting 
f73400a233fd: Waiting 
47cd406a84ef: Waiting 
bae5a1799a80: Waiting 
error pulling image configuration: download failed after attempts=6: dial tcp 3.5.189.55:443: i/o timeoutName:             

kubectl describe pod -n game-2048 deployment-2048-58dc5c4b77-7knhj
Name:             deployment-2048-58dc5c4b77-7knhj
Namespace:        game-2048
Priority:         0
Service Account:  default
Node:             ip-10-0-5-215.ap-northeast-2.compute.internal/10.0.5.215
Start Time:       Wed, 18 Feb 2026 15:05:23 +0000
Labels:           app.kubernetes.io/name=app-2048
                  pod-template-hash=58dc5c4b77
                  topology.kubernetes.io/region=ap-northeast-2
                  topology.kubernetes.io/zone=ap-northeast-2c
Annotations:      kubectl.kubernetes.io/restartedAt: 2026-02-18T15:05:22Z
Status:           Pending
IP:               10.0.5.235
IPs:
  IP:           10.0.5.235
Controlled By:  ReplicaSet/deployment-2048-58dc5c4b77
Containers:
  app-2048:
    Container ID:   
    Image:          635645195625.dkr.ecr.ap-northeast-2.amazonaws.com/docker-hub/alexwhen/docker-2048:latest
    Image ID:       
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-4sbg7 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       False 
  ContainersReady             False 
  PodScheduled                True 
Volumes:
  kube-api-access-4sbg7:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                  From               Message
  ----     ------     ----                 ----               -------
  Normal   Scheduled  10m                  default-scheduler  Successfully assigned game-2048/deployment-2048-58dc5c4b77-7knhj to ip-10-0-5-215.ap-northeast-2.compute.internal
  Normal   Pulling    7m46s (x5 over 10m)  kubelet            Pulling image "635645195625.dkr.ecr.ap-northeast-2.amazonaws.com/docker-hub/alexwhen/docker-2048:latest"
  Warning  Failed     7m46s (x5 over 10m)  kubelet            Failed to pull image "635645195625.dkr.ecr.ap-northeast-2.amazonaws.com/docker-hub/alexwhen/docker-2048:latest": rpc error: code = NotFound desc = failed to pull and unpack image "635645195625.dkr.ecr.ap-northeast-2.amazonaws.com/docker-hub/alexwhen/docker-2048:latest": failed to resolve reference "635645195625.dkr.ecr.ap-northeast-2.amazonaws.com/docker-hub/alexwhen/docker-2048:latest": 635645195625.dkr.ecr.ap-northeast-2.amazonaws.com/docker-hub/alexwhen/docker-2048:latest: not found
  Warning  Failed     7m46s (x5 over 10m)  kubelet            Error: ErrImagePull
  Normal   BackOff    44s (x43 over 10m)   kubelet            Back-off pulling image "635645195625.dkr.ecr.ap-northeast-2.amazonaws.com/docker-hub/alexwhen/docker-2048:latest"
  Warning  Failed     44s (x43 over 10m)   kubelet            Error: ImagePullBackOff