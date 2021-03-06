#!/bin/bash
echo Detecting system version..
cat /etc/redhat-release
#read -t 300 -p "请输入你的域名：" domain
#read -t 300 -p "请输入你的邮箱(用于申请ssl证书)：" email
#read -t 300 -p "请设定你的数据库root密码(务必牢记)：" dbpasswd
yum -y update
yum -y install nginx
systemctl start nginx
systemctl enable nginx
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
##yum -y install php72w-common
wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server
systemctl restart mysqld
yum -y install epel-release
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum-config-manager --enable remi-php72
yum -y update
yum -y install php72
yum -y install php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-opcache
systemctl enable php72-php-fpm.service
systemctl start php72-php-fpm.service
##yum -y install php72w-fpm
##systemctl restart php-fpm
##systemctl enable php-fpm
cd /etc/nginx
wget https://yimian-setup.obs.myhwclouds.com/std-conf/nginx.conf -O nginx.conf
#sed 's/your_domain/$domain/g' nginx.conf
#yum install -y epel-release
#yum install -y certbot
#certbot certonly --webroot -w /opt/www/$domain -d $domain -m $email --agree-tos
##cd /etc/php-fpm.d
##wget https://yimian-setup.obs.myhwclouds.com/std-conf/www.conf -O www.conf
cd /etc
wget https://yimian-setup.obs.myhwclouds.com/std-conf/my.cnf -O my.cnf
systemctl restart mysqld
##yum -y install php72w-mysql
systemctl restart nginx
##systemctl restart php-fpm
cd /home
wget http://typecho.org/downloads/1.1-17.10.30-release.tar.gz
tar -xvf 1.1-17.10.30-release.tar.gz
mv build www
chmod 777 -R www
systemctl restart nginx
cd /etc/selinux
wget https://yimian-setup.obs.myhwclouds.com/std-conf/config -O config
setenforce 0
systemctl start firewalld
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
echo Auto Install finished!!
echo 安装完成！！
echo 请开始设置你的数据库
echo 请输入以下内容设置数据库root密码 
echo 
echo "*****************************************************************"
echo use mysql
echo "UPDATE user SET Password = '你的密码' WHERE User = 'root';"
echo "create database typecho;"
echo quit
echo "*****************************************************************"
echo 
mysql -uroot
echo 自动安装程序运行完成！！
echo 请使用浏览器输入 http://你的服务器ip 访问typecho
