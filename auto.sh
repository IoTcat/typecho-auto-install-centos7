#!/bin/bash
echo Detecting system version..
cat /etc/redhat-release
read -t 300 -p "请输入你的域名：" domain
read -t 300 -p "请输入你的邮箱(用于申请ssl证书)：" email
read -t 300 -p "请设定你的数据库root密码(务必牢记)：" dbpasswd
#yum -y update
yum -y install nginx
systemctl start nginx
systemctl enable nginx
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y install php72w-common
wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server
systemctl restart mysqld
yum -y install php72w-fpm
systemctl restart php-fpm
systemctl enable php-fpm
cd /etc/nginx
wget https://yimian-setup.obs.myhwclouds.com/std-conf/nginx.conf -O nginx.conf
sed 's/your_domain/$domain/g' nginx.conf
yum install -y epel-release
yum install -y certbot
certbot certonly --webroot -w /opt/www/$domain -d $domain -m $email --agree-tos
cd /etc/php-fpm.d
wget https://yimian-setup.obs.myhwclouds.com/std-conf/www.conf -O www.conf
cd /etc
wget https://yimian-setup.obs.myhwclouds.com/std-conf/my.cnf -O my.cnf
systemctl restart mysqld
yum -y install php72w-mysql
systemctl restart nginx
systemctl restart php-fpm
cd /home
wget http://typecho.org/downloads/1.1-17.10.30-release.tar.gz
tar -xvf 1.1-17.10.30-release.tar.gz
mv build www
systemctl restart nginx
cd /etc/selinux
wget https://yimian-setup.obs.myhwclouds.com/std-conf/config -O config
setenforce 0
systemctl start firewalld
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
echo Auto Install finished!!
