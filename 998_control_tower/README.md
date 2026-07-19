# Control Tower

## Baselines ([list](https://docs.aws.amazon.com/ko_kr/controltower/latest/userguide/types-of-baselines.html#lz-baseline-types)) @ July 2026

```
$ aws controltower list-baselines
{
    "baselines": [
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/4T4HA1KMO10S6311",
            "name": "AuditBaseline",
            "description": "Sets up resources to monitor security and compliance of accounts in your organization."
        },
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/A6EEAE10F08193F2",
            "name": "CentralSecurityRolesBaseline",
            "description": "Sets up central resources for security monitoring within your organization."
        },
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/J8HX46AHS5MIKQPD",
            "name": "LogArchiveBaseline",
            "description": "Sets up a central repository for logs of API activities and resource configurations from accounts in your organization."
        },
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/LN25R72TTG6IGPTQ",
            "name": "IdentityCenterBaseline",
            "description": "Sets up shared resources for AWS Identity Center, which prepares the AWSControlTowerBaseline to set up Identity Center access for accounts."
        },
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/17BSJV3IGJ2QSGA2",
            "name": "AWSControlTowerBaseline",
            "description": "Sets up resources and mandatory controls for member accounts within the target OU, required for AWS Control Tower governance."
        },
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/3WPD0NA6TJ9AOMU2",
            "name": "BackupCentralVaultBaseline",
            "description": "Sets up a central AWS Backup vault in your organization."
        },
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/H6C5JFCJJ3CPU3J5",
            "name": "BackupAdminBaseline",
            "description": "Sets up AWS Backup Audit Manager."
        },
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/APO9ATVPBKFRRGLK",
            "name": "BackupBaseline",
            "description": "Sets up a local AWS Backup vault and attaches multiple AWS Backup plans."
        },
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/YX7VMZML5IG8EJUD",
            "name": "CentralConfigBaseline",
            "description": "Sets up central resources for compliance monitoring and auditing within your organization using AWS Config."
        },
        {
            "arn": "arn:aws:controltower:ap-northeast-2::baseline/1QBGH2G48YVGDQ3Y",
            "name": "ConfigBaseline",
            "description": "Sets up AWS Config resources for member accounts within the target OU, required for Detective Controls enablement. The resources set up are a subset of resources of AWSControlTowerBaseline."
        }
    ]
}
```