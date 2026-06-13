# EKS + Multus CNI

## AL2023 Node : Primary ENI + Secondary ENIs
- Primary ENI ( io.systemd.Network / ManagerSystemd ) -> `/run/systemd/network/70-eks-ensX.network`
  
  (configured)
  
  ```
  # networkctl status ens5
  systemd-networkd[XXXX]: Configuring with /usr/lib/systemd/network/80-ec2.network.
  systemd-networkd[XXXX]: ens5: Link UP
  systemd-networkd[XXXX]: ens5: Gained carrier
  systemd-networkd[XXXX]: ens5: DHCPv4 address x.x.x.x/x, gateway x.x.x.x acquired from x.x.x.x
  systemd-networkd[XXXX]: ens5: Gained IPv6LL
  systemd-networkd[XXXX]: ens5: Reconfiguring with /run/systemd/network/70-eks-ens5.network.
  systemd-networkd[XXXX]: ens5: DHCP lease lost
  systemd-networkd[XXXX]: ens5: DHCPv6 lease lost
  systemd-networkd[XXXX]: ens5: DHCPv4 address x.x.x.x/x, gateway x.x.x.x acquired from x.x.x.x
  ```

- Secondary ENI ( cni / ManagerCNI )
  
  (unmanaged)

  - IPAMD (vpc-cni) -> [AWS_VPC_ENI_MTU](https://github.com/aws/amazon-vpc-cni-k8s/tree/master#aws_vpc_eni_mtu-v160) Configuration Variable (Default 9001)

    ```
    # networkctl status ens6
    systemd-networkd[XXXX]: ens6: Configuring with /usr/lib/systemd/network/80-ec2.network.
    systemd-networkd[XXXX]: ens6: Link UP
    systemd-networkd[XXXX]: ens6: Gained carrier
    systemd-networkd[XXXX]: ens6: DHCPv4 address x.x.x.x/x, gateway x.x.x.x acquired from x.x.x.x
    systemd-networkd[XXXX]: ens6: Gained IPv6LL
    systemd-networkd[XXXX]: ens6: Unmanaging interface.
    systemd-networkd[XXXX]: ens6: DHCP lease lost
    systemd-networkd[XXXX]: ens6: DHCPv6 lease lost
    ```

  - Multus ( [ENI Resource Tag : node.k8s.amazonaws.com/no_manage = true](https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/pod-multus.html) ) -> `/usr/lib/systemd/network/80-ec2.network`
    
    ```
    # networkctl status ens6
    systemd-networkd[XXXX]: ens6: Configuring with /usr/lib/systemd/network/80-ec2.network.
    systemd-networkd[XXXX]: ens6: Link UP
    systemd-networkd[XXXX]: ens6: Gained carrier
    systemd-networkd[XXXX]: ens6: DHCPv4 address x.x.x.x/x, gateway x.x.x.x acquired from x.x.x.x
    systemd-networkd[XXXX]: ens6: Gained IPv6LL
    systemd-networkd[XXXX]: ens6: Unmanaging interface.
    systemd-networkd[XXXX]: ens6: DHCP lease lost
    systemd-networkd[XXXX]: ens6: DHCPv6 lease lost
    ```

- Secondary ENI ( io.systemd.Network / ManagerSystemd ) -> `/run/systemd/network/70-eks-ensX.network`

    (configured)

    -> nodeadm-boot-hook.service `secondary link not yet unmanaged {"linkName": "ensX", "linkState": "configured"}`
    
    -> nodeadm-boot-hook.service `failed to ensure primary ENI only configuration: context deadline exceeded`

    ```
    # networkctl status ens7
    systemd-networkd[XXXX]: ens7: Configuring with /usr/lib/systemd/network/80-ec2.network.
    systemd-networkd[XXXX]: ens7: Link UP
    systemd-networkd[XXXX]: ens7: Gained carrier
    systemd-networkd[XXXX]: ens7: DHCPv4 address x.x.x.x/x, gateway x.x.x.x acquired from x.x.x.x
    systemd-networkd[XXXX]: ens7: Gained IPv6LL
    systemd-networkd[XXXX]: ens7: Reconfiguring with /run/systemd/network/70-eks-ens7.network.
    systemd-networkd[XXXX]: ens7: DHCP lease lost
    systemd-networkd[XXXX]: ens7: DHCPv6 lease lost
    systemd-networkd[XXXX]: ens7: DHCPv4 address x.x.x.x/x, gateway x.x.x.x acquired from x.x.x.x
    ```

## References
- [Pod Multus](https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/pod-multus.html)
- [Multus GitHub](https://github.com/k8snetworkplumbingwg/multus-cni#quickstart-installation-guide)