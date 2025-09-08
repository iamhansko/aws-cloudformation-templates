# EKS Custom Networking

## Notes
- aws-node DaemonSet의 "AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG" 환경변수를 true로 바꾼 이후에 생성된 노드의 경우, ENIConfig가 없거나 노드와의 통신이 (보안그룹 상) 막혀 있을 경우 aw-node가 정상 실행되지 못하고 노드의 조인도 실패합니다.
- 클러스터 보안그룹에서 ENIConfig 보안그룹 인바운드를 허용해야 coredns 파드가 실행되지 못합니다.
- 클러스터 보안그룹에서 ENIConfig 보안그룹 인바운드를 허용하고, ENIConfig 보안그룹에서 클러스터 보안그룹 인바운드(9443)를 허용해야 aws-load-balancer-webhook ValidatingWebhook과 통신이 이루어져 ALB/NLB 제어가 가능합니다.
- IRSA가 적용된 파드는 파드 서브넷 IGW/NATGW/VPCE가 아닌 노드 서브넷 IGW/NATGW/VPCE를 통해 Web ID Token을 요청합니다.