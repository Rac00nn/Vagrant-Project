#!/bin/bash
set -e

if [ "$EUID" -ne "0" ] ; then
		echo "Script must be run as root." >&2
		exit 1
fi

#Enable EPEL Repository
yum install epel-release -y

#Installing necessary updates
yum update -y --exclude=kernel

#Install Group BASE
yum groupinstall "base"

#Install some tools
yum install -y git nano unzip screen net-tools elinks

#Install SELinux tools
yum install -y setroubleshoot setroubleshoot-server policycoreutils-python policycoreutils-devel setools-console

#Enable Apache Permisive Mode
semanage permisive -a httpd_t

#Apache
yum install -y httpd httpd-devel httpd-tools
systemctl stop httpd

rm -rf /var/www/html
ln -fs /vagrant /var/www/html

#PHP
yum install -y php php-devel php-mysql php-cli php-common phpMyAdmin

#Mysql
yum install -y mariadb-server mariadb-devel

#Start & Enable Services
systemctl enable mariadb
systemctl start mariadb
systemctl enable httpd
systemctl start httpd

echo "vagrant ALL=(ALL)	NOPASSWD: ALL" >> /etc/sudoers
