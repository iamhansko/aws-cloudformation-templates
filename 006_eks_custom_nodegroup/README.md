# EKS Cluster - Custom Managed Node Group (MNG)

## Architecture
[Kubernetes]

<img src="assets/k8s.png">

## Preview
<img src="assets/test.gif">

## Notes

Custom Launch Template
- AMI (optional)
- InstanceType (optional)
- Subnet(s) (optional)
- SecurityGroup(s) (optional)
- UserData (empty(Auto) or mime-multipart(AL2023) or ...) (required if AMI is specified)
- IamRole(InstanceProfile) (don't include)

Managed Node Group - Merged User Data Example
```
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==BOUNDARY=="

# NodeConfig is automatically added by MNG
--==BOUNDARY==
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    apiServerEndpoint: API_SERVER_ENDPOINT
    certificateAuthority: CERTIFICATE_AUTHORITY_DATA
    cidr: 172.20.0.0/16
    name: CLUSER_NAME
  kubelet:
    config:
      maxPods: 110
      clusterDNS:
      - 172.20.0.10

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
yum update -y
timedatectl set-timezone Asia/Seoul

--==BOUNDARY==--
```

NodeConfig -> /etc/kubernetes/kubelet/config.json.d/40-nodeadm.conf
```
ps aux | grep kubelet

#############
#   base    #
#############
cat /etc/kubernetes/kubelet/config.json

#############
# overwrite #
#############
cat /etc/kubernetes/kubelet/config.json.d/40-nodeadm.conf

# https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/#kubelet-conf-d
```

Managed Node Group - User Data Types
- MIME multipart format + shell script (O)
- MIME multipart format + shell script + NodeConfig (O)
- MIME multipart format + shell script + NodeConfig + NodeConfig (O) (the last NodeConfig applied)
- shell script (x)
- NodeConfig (x)

Load Test
```
kubectl run load-generator --image=busybox -- /bin/sh -c "while true; do wget -q -O - http://php-apache; done"
```