# EKS Backup

## Requirements
- Authentication Mode : API / API_AND_CONFIG_MAP
- Backup IAM Role : AWSBackupServiceRolePolicyForBackup Policy
- Restore IAM Role : AWSBackupServiceRolePolicyForBackup Policy
- (Auto) IAM Access Entry : AWSBackupServiceRolePolicyForBackup Acess Policy
- (Optional) Backup Vault KMS Key

## Restore Target Resources
- Pods ( Fargate randomly ? )
- Deployments ✅ / Statefulsets ✅
- EBS / S3 / EFS PersistentVolumes ✅
- ServiceAccounts ✅
- Roles / RoleBindings ✅
- ClusterRoles / ClusterRoleBindings ✅ (if `AmazonEKSClusterAdminPolicy` associated)
- Managed Node Groups ✅ (New Cluster)
- Fargate Profiles ✅ (New Cluster)
- AddOns ✅ (New Cluster)
- Pod Identity Assocations ✅ (New Cluster)
- Services / Ingresses (X)
- IAM OIDC Provider (X)
- ECR Images (X)

## Backup / Restore
```
# EKS Backup ( Completed / Partial / Failed )
aws backup start-backup-job \
--backup-vault-name my-backup-vault \
--resource-arn arn:aws:eks:us-west-2:123456789012:cluster/my-cluster \
--iam-role-arn arn:aws:iam::123456789012:role/AWSBackupDefaultServiceRole

# EKS Restore
aws backup start-restore-job \
--recovery-point-arn "arn:aws:backup:us-west-2:123456789012:recovery-point:composite:eks/my-cluster" \
--iam-role-arn "arn:aws:iam::123456789012:role/AWSBackupDefaultServiceRole" \
--metadata '{ ... }' \
--resource-type "EKS"
```

## Limitations
- Persistent volumes using a CSI Driver via CSI migration, in-tree storage plugins or ACK controllers are not supported. Note that the annotation volume.kubernetes.io/storage-provisioner: ebs.csi.aws.com is metadata indicating which provisioner could manage the volume, not that the volume uses CSI. The actual provisioner is determined by the storageClass.
- Amazon S3 buckets with specific prefixes attached to CSI Driver MountPoints cannot be backed up. Only Amazon S3 buckets as targets are supported, not specific prefixes.
- Amazon S3 bucket backups as part of an EKS cluster backup will only support snapshot backups.
- Amazon FSx via CSI driver is not supported via EKS Backups.
- AWS Backup does not support Amazon EKS on AWS Outposts.

## References
- [EKS Backup](https://docs.aws.amazon.com/ko_kr/aws-backup/latest/devguide/eks-backups.html)
- [EKS Restore](https://docs.aws.amazon.com/ko_kr/aws-backup/latest/devguide/restoring-eks.html)