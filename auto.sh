#!/bin/bash
cat /etc/redhat-release
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
wget -O nginx.conf https://yimian-setup.obs.myhwclouds.com/std-conf/nginx.conf
cd /etc/php-fpm.d
wget -O www.conf https://yimian-setup.obs.myhwclouds.com/std-conf/www.conf
cd /etc
wget -O my.cnf https://yimian-setup.obs.myhwclouds.com/std-conf/my.cnf
systemctl restart mysqld
yum -y install php72w-mysql
systemctl restart nginx
systemctl restart php-fpm
cd /home
wget http://typecho.org/downloads/1.1-17.10.30-release.tar.gz
tar -xvf 1.1-17.10.30-release.tar.gz
mv build www
