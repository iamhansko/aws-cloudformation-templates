#!/bin/bash

# Pod 접속(curl 테스트 등)
kubectl run curl --image=curlimages/curl --restart=Never
kubectl exec -it curl -n FARGATE_PROFILE_NAMESPACE -- sh