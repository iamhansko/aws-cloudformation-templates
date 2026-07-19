# EKS API Server Endpoints + VPC Lattice

Amazon VPC Lattice allows you to publish and access services across VPCs in a scalable and secure way. With DNS-based resource configurations, you can expose your EKS cluster API endpoint through a VPC Lattice service network. On the client side, VPCs can connect using either:

    - Service Network Association (SN-A): private access within a VPC the a service network

    - Service Network Endpoint (SN-E): for private access both inside and outside the VPC (including Direct Connect, VPN, or Cloud WAN paths)

**1 VpcLattice ResourceConfiguration : 1 EksCluster ApiServerEndpoint**

## References
- [Private connectivity to Amazon EKS cluster API endpoints using VPC Lattice](https://repost.aws/articles/AR-60v9yfzQwe8Wc52fyEehQ/private-connectivity-to-amazon-eks-cluster-api-endpoints-using-vpc-lattice)