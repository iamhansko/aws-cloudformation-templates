# Node Monitoring Agent

## NetworkingReady

#### InterfaceNotUp (Condition)
```
sudo iplink show
sudo iplink set ens5 down
```

#### IPAMDNotReady Test (Condition)
```
while true; do echo '{"level":"debug","ts":"2025-08-12T23:39:04.306Z","caller":"ipamd/ipamd.go:1310","msg":"Unable to reach API Server"}' >> /var/log/aws-routed-eni/ipamd.log; sleep 30; done
```

#### UnexpectedRejectRule Test (Event)
```
sudo iptables -A INPUT -p tcp --dport 6443 -j DROP
```

## KernelReady

#### ForkFailedOutOfPID Test (Condition)
```
sudo sysctl -w kernel.pid_max=5000 
for i in {1..5000}; do sleep 10000 & done
```

## ContainerRuntimeReady

#### PodStuckTerminating Test (Condition)
```
while true; do logger -t kubelet "\"Pod still has one or more containers in the non-exited state and will not be removed from desired state\" pod=\"default/dummy\""; sleep 60; done
```

## StorageReady

#### XFSSmallAverageClusterSize Test (Event)
```
#!/bin/bash

if [ ! -f /usr/sbin/xfs_db.orig ]; then
cp /usr/sbin/xfs_db /usr/sbin/xfs_db.orig
fi

cat > /tmp/xfs_db << 'EOF'
#!/bin/bash
if [[ "$*" == *"freesp -s"* ]] && [[ "$*" == *"/dev/nvme0n1p1"* ]]; then
cat << 'FAKE_OUTPUT'
   from      to extents  blocks    pct
      1       1     103     103   0.00
      2       3      14      32   0.00
      4       7       5      31   0.00
      8      15       6      61   0.00
     16      31       6     160   0.00
total free extents 134
total free blocks 387
average free extent size 2.8881
FAKE_OUTPUT
exit 0
fi
/usr/sbin/xfs_db.orig "$@"
EOF

chmod +x /tmp/xfs_db
sudo cp /tmp/xfs_db /usr/sbin/xfs_db
sudo chmod +x /usr/sbin/xfs_db

xfs_db -r -c "freesp -s" /dev/nvme0n1p1
```