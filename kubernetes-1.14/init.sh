#!/bin/sh
sudo timedatectl set-timezone Asia/Shanghai;
hostnamectl set-hostname node1;    #修改你的节点名
#关闭防火墙服务
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config;
setenforce 0;
systemctl disable firewalld;
systemctl stop firewalld;
cd /usr/local/k8s-install;
tar -zxvf docker-ce-18.09.tar.gz;
cd /usr/local/k8s-install/docker;
yum  -y localinstall *.rpm;
systemctl start docker && systemctl enable docker;
sudo mkdir -p /etc/docker;
cp /usr/local/k8s-install/daemon.json /etc/docker/daemon.json;
sudo systemctl daemon-reload;
sudo systemctl restart docker;
cd /usr/local/k8s-install;
tar -zxvf kube114-rpm.tar.gz ;
cd kube114-rpm;
yum -y localinstall *.rpm;
swapoff -a;
sed -i '$d' /etc/fstab ;
cp /usr/local/k8s-install/k8s.conf /etc/sysctl.d/k8s.conf
cd /usr/local/k8s-install;
docker load -i k8s-114-images.tar.gz;
docker load -i flannel-dashboard.tar.gz;
echo "K8S INIT FINISH!!!"
