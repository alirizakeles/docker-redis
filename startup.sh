#!/bin/bash

echo 511 > /proc/sys/net/core/somaxconn
echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
echo never > /sys/kernel/mm/transparent_hugepage/enabled
sysctl vm.overcommit_memory=1

chmod +x /etc/rc.d/rc.local
echo "echo 511 > /proc/sys/net/core/somaxconn" >> /etc/rc.d/rc.local
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.d/rc.local

mkdir -p /data/redis/server
mkdir -p /data/redis/sentinel

docker run --restart=on-failure --net host -v /data/redis/server:/data -d onedio/redis
docker run --restart=on-failure --net host -v /data/redis/sentinel:/data -d onedio/redis redis-server /redis/sentinel.conf --sentinel
