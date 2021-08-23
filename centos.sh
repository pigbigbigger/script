#! /bin/bash
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/pigbigbigger/script/main/centos.sh)"
# sudo visudo
#
# /etc/ssh/sshd_config
# change to:
# PasswordAuthentication yes
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# create user
adduser yaoo
passwd='Yangok1234567'
if [ "$1" != "" ];then
    passwd=$1
fi
echo  "set yaoo pass [$passwd]"
echo -e "$passwd\n$passwd" | passwd yaoo
grep '^yaoo' /etc/sudoers
if [ "$?" != 0 ];then
    # add sudo users.
    sed -i "/^root/a yaoo ALL=(ALL) ALL" /etc/sudoers
fi

# hostnamectl --static set-hostname bcweb.tw

yes | yum update
yes | yum install httpd
#systemctl restart httpd
yes | yum install nginx
yum -y install gcc automake autoconf libtool make 
yum -y install gcc+ gcc-c++
systemctl restart nginx
systemctl enable nginx

if [ ! -f /var/www/html/index.html ];then
	echo "install black index.html"
	echo "" >/var/www/html/index.html
fi

# nginx default html(blank)
if [ ! -f /usr/share/nginx/html/index.html-orig ]; then
	mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html-orig
	echo "" >/usr/share/nginx/html/index.html
fi

yes | yum install git
yes | yum install unzip
yes | yum install libconfig

# disable selinux
setenforce 0
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

yes | yum install nodejs
npm install -g web3
npm install -g tronweb
npm install -g yarn
npm install -g react-scripts

#export NODE_PATH=/usr/local/lib/node_modules
if ! grep -q '^export NODE_PATH=/usr/local/lib/node_modules' /home/yaoo/.bashrc ; then
	echo 'export NODE_PATH=/usr/local/lib/node_modules' >>/home/yaoo/.bashrc
	source /home/yaoo/.bashrc
fi

alternatives --set python /usr/bin/python3

# install epel-release
dnf install epel-release -y
#dnf install snapd -y
#systemctl enable --now snapd.socket
#systemctl start snapd
#snap install shadowsocks-libev

# add chmod
chmod +rx /var/log/nginx

# ssh passwd
ssh1='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuFnzwnhKuFtEu8sLgtXPekcVvvHW12QY2HWdr+TXigYGejcBb/1RphjHPr0QjZbCBCJsIZ1PRINYhmv+7H4hj3WaztXDFI5SieH2SmVEnYp2obYpK9oHFA+gVAbxq3agX6N2IKMiCk8RIYx8481lnnFwn9r+MUMntKC8qARywKMOR+Z/8/KTR5CYncAZ4C/xtE5ka0vlCM87zIYUQ5GrZW4AiyAeBkcI8G20FlMwuzVtU3YoUVSJ0zTNEG1w+5T4knIoWbYZSb63K8/B/XEfNpwKzoxiq3WqqATZgGKorn9TKdGYDOKTp0MFShHC+7OSekg17zfLUy8uq2/4291Rf 356538277@qq.com'

mkdir /home/yaoo/.ssh
mkdir /root/.ssh
chmod 700 /home/yaoo/.ssh
chmod 700 /root/.ssh
echo $ssh1 >>/home/yaoo/.ssh/authorized_keys
echo $ssh1 >>/root/.ssh/authorized_keys
chown -R yaoo.yaoo /home/yaoo/.ssh
