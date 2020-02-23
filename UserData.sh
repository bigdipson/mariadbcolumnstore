#!/bin/bash

################################################
#       Author  : Oladipo Olaniyan
#       Date    : 21/02/2020
#
################################################
# Switching to root user
#sudo su -
# Updating depentacies and support tools
sudo apt-get update
sudo apt-get -y install libboost-all-dev
sudo apt-get -y install dirmngr apt-transport-https wget expect perl openssl file sudo runit rsyslog curl nano gnupg2 procps bc
sudo apt-get -y install libdbi-perl libreadline-dev
sudo apt-get -y install rsync libsnappy1v5 net-tools libdbd-mysql-perl

# Download the ColumnStore 1.2.5 and install
cd /root/
wget https://downloads.mariadb.com/ColumnStore/latest/debian/dists/stretch/main/binary_amd64/mariadb-columnstore-1.2.5-1-stretch.amd64.deb.tar.gz
tar -zxvf mariadb-columnstore-1.2.5-1-stretch*
rm mariadb-columnstore-1.2.5-1-stretch*
dpkg -i mariadb-columnstore*

#Create the symlink for important binaries

mkdir /etc/columnstore
ln -s /usr/local/mariadb/columnstore/bin/postConfigure /bin/postConfigure
ln -s /usr/local/mariadb/columnstore/bin/columnstore /bin/columnstore
ln -s /usr/local/mariadb/columnstore/bin/mcsadmin /bin/mcsadmin
ln -s /usr/local/mariadb/columnstore/mysql/bin/mysql /bin/mysql 
ln -s /usr/local/mariadb/columnstore/etc/Columnstore.xml /etc/columnstore/Columnstore.xml
#Script End
