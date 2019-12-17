#!/bin/bash

#sudo wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+bionic_all.deb
#sudo dpkg -i zabbix-release_4.0-2+bionic_all.deb

#sudo wget https://repo.zabbix.com/zabbix/4.0/raspbian/pool/main/z/zabbix-release/zabbix-release_4.0-3+stretch_all.deb 
#sudo dpkg -i zabbix-release_4.0-3+stretch_all.deb

sudo apt update

#sudo apt install mariadb-server
#sudo apt install mysql-server
apt-get install mysql-server mysql-client -y


#----
apt-get --purge remove mysql-server -y
apt-get --purge remove mysql-client -y
apt-get --purge remove mysql-common -y
apt-get autoremove
apt-get autoclean
rm -rf /etc/mysql
apt-get install mysql-server mysql-client 

sudo apt install zabbix-server-mysql -y
sudo apt install zabbix-frontend-php -y
sudo apt install zabbix-agent -y
sudo apt install git curl php-curl mc htop -y

sudo apt-get install php-ldap

sudo mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
sudo mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'plamya';"
sudo mysql -uroot -e "FLUSH PRIVILEGES;"
sudo mysql -uroot -e "quit"

#sudo zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | sudo mysql -uzabbix zabbix -pplamya
sudo zcat /usr/share/zabbix-server-mysql/schema.sql.gz | sudo mysql -uzabbix zabbix -pplamya
sudo zcat /usr/share/zabbix-server-mysql/images.sql.gz | sudo mysql -uzabbix zabbix -pplamya
sudo zcat /usr/share/zabbix-server-mysql/data.sql.gz | sudo mysql -uzabbix zabbix -pplamya


sudo git clone https://github.com/vasyakrg/zabbix-alert-scripts.git /usr/lib/zabbix/alertscripts
sudo chown -R zabbix:root /usr/lib/zabbix/alertscripts

sudo cp ~/zabconf/zabbix_server.conf /etc/zabbix
sudo cp ~/zabconf/apache.conf /etc/zabbix

sudo service mysql restart
sudo service apache2 restart
sudo service zabbix-server restart
sudo update-rc.d zabbix-server enable
