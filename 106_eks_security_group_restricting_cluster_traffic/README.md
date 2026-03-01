# EKS Security Group Restricting Cluster Traffic

## EKS Cluster Updates (Control Plane)
- VersionUpdate : Inbound / Outbound Rules
    - Inbound Rule : All Ports + Self Source (Allows EFA traffic, which is not matched by CIDR rules.)
    - Outbound Rule : All Ports + 0.0.0.0/0 Destination (Allows EFA traffic, which is not matched by CIDR rules.)
- VpcConfigUpdate : No Change (Inbound / Outbound Rules)
- EndpointAccessUpdate : No Change (Inbound / Outbound Rules)