#!/usr/bin/env bash

# initialize variables
DBNAME=TESTBASE
MASTERHOST=192.168.56.11
DBPASSWD=securityfirst

# replication user
RUSER=replicator
RPASSWD=securityfirst

# copy mysql config
cp /vagrant/50-master.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

sudo service mysql restart

# create replication user and grant access
mysql -uroot -p$DBPASSWD -e "CREATE USER '$RUSER'@'$DBHOST' IDENTIFIED BY '$RPASSWD';"
mysql -uroot -p$DBPASSWD -e "GRANT REPLICATION SLAVE ON *.* TO '$RUSER'@'$DBHOST';"
mysql -uroot -p$DBPASSWD -e "FLUSH PRIVILEGES;"

sudo service mysql restart



