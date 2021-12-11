timedatectl set-timezone Asia/Shanghai
hostnamectl set-hostname node1    #修改你的节点名
#关闭防火墙服务
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
systemctl disable firewalld
systemctl stop firewalld
cd /usr/local/k8s-install
tar -zxvf docker-ce-18.09.tar.gz
cd /usr/local/k8s-install/docker
yum  -y localinstall *.rpm

#启动docker服务
systemctl start docker && systemctl enable docker

#加入阿里云加速
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://fskvstob.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

swapoff -a
sed '$d' /etc/fstab 
#修改iptable
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
#安装kubeadm
cd /usr/local/k8s-install
docker load -i k8s-114-images.tar.gz
docker load -i flannel-dashboard.tar.gz



