# EKS Soft Multi Tenancy

1. Namespace-per-Tenant Isolation : two tenants (tenant-a, tenant-b) each get their own namespace, ResourceQuota/LimitRange (quota isolation), and an IAM role mapped via AWS::EKS::AccessEntry scoped to only their namespace (RBAC/access-control isolation, least privilege).

2. Network Isolation between Tenants : adapting the EKS Network Policy ([Stars Demo](https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/network-policy-stars-demo.html)). Each tenant runs its own frontend/backend pair, a shared management-ui visualizes connectivity across both tenants, and default-deny + allow-ui + backend-policy NetworkPolicies are applied per tenant so that frontend-a can reach backend-a but NOT backend-b (and vice versa), proving tenant network isolation while the platform-level management-ui can still observe both tenants.

## Stars Demo Manifests

`frontend-a -> backend-a` works while `frontend-a -> backend-b` is blocked (and vice versa)

  - `frontend-a` -> `backend-a` (O)
  - `frontend-a` -> `backend-b` (X)
  - `frontend-b` -> `backend-a` (O)
  - `frontend-b` -> `backend-b` (X)

- [tenant-a / tenant-b / management-ui namespaces](https://raw.githubusercontent.com/aws-samples/eks-workshop/2f9d29ed3f82ed6b083649e975a0e574fb8a4058/content/beginner/120_network-policies/calico/stars_policy_demo/create_resources.files/namespace.yaml)

- `ResourceQuota` + `LimitRange` per tenant

- per-tenant [frontend](https://raw.githubusercontent.com/aws-samples/eks-workshop/2f9d29ed3f82ed6b083649e975a0e574fb8a4058/content/beginner/120_network-policies/calico/stars_policy_demo/create_resources.files/frontend.yaml)/[backend](https://raw.githubusercontent.com/aws-samples/eks-workshop/2f9d29ed3f82ed6b083649e975a0e574fb8a4058/content/beginner/120_network-policies/calico/stars_policy_demo/create_resources.files/backend.yaml) `star` workloads + shared management-ui

  - `frontend-a` Deployment / Service
  - `frontend-b` Deployment / Service
  - `backend-a` Deployment / Service
  - `backend-b` Deployment / Service
  - `management-ui` Deployment / Service(LoadBalancer)

- `NetworkPolicies` per tenant

  - `default-deny` (1 policy : 1 tenant)
  - `allow-ui` (1 policy : 1 tenant)
  - `backend-policy` (1 policy : 1 tenant)

- [Management UI workloads](https://raw.githubusercontent.com/aws-samples/eks-workshop/2f9d29ed3f82ed6b083649e975a0e574fb8a4058/content/beginner/120_network-policies/calico/stars_policy_demo/create_resources.files/management-ui.yaml)

- [Client workloads](https://raw.githubusercontent.com/aws-samples/eks-workshop/2f9d29ed3f82ed6b083649e975a0e574fb8a4058/content/beginner/120_network-policies/calico/stars_policy_demo/create_resources.files/client.yaml)

## References
- [kubernetes multi tenancy](https://kubernetes.io/ko/docs/concepts/security/multi-tenancy/)
- [network policy](https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/network-policy-stars-demo.html)