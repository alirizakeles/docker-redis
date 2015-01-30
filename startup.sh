#!/bin/bash

echo 511 > /proc/sys/net/core/somaxconn
echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
echo never > /sys/kernel/mm/transparent_hugepage/enabled
sysctl vm.overcommit_memory=1

chmod +x /etc/rc.d/rc.local
echo "echo 511 > /proc/sys/net/core/somaxconn" >> /etc/rc.d/rc.local
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.d/rc.local

docker run --restart always --net host -v /data:/data -d onedio/redis
docker run --restart always --net host -d onedio/redis redis-server /redis/sentinel.conf --sentinel
