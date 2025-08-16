# EKS CloudFormation Templates

## Computing
EKS 클러스터는 ControlPlane + WorkerNode(s)로 구성됩니다.
ControlPlane은 AWS 내부에서 관리합니다.
WorkerNode(s)는 사용자가 관리합니다.  
사용자가 WorkerNode(s)를 구성하는 방식은 다음 3가지가 있습니다.

- [Managed Node Group](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html)
- [Fargate](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html)
- [Auto Mode](https://docs.aws.amazon.com/eks/latest/userguide/automode.html)

## How to Use
1. Go To [CloudFormation Console](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create)
2. [템플릿 소스] > [템플릿 파일 업로드] 선택
3. 파일 선택, YAML 파일 업로드, [다음] 선택
4. [스택 이름] 설정, 필요시 KubernetesVersion 변경, [다음] 선택
5. [기능] > "AWS CloudFormation에서 사용자 지정 이름으로 IAM 리소스를..." 체크, [다음] 선택
6. [전송] 선택