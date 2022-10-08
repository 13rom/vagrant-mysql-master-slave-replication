#!/usr/bin/env bash

# initialize variables
DBNAME=TESTBASE
MASTERHOST=192.168.56.11
DBPASSWD=securityfirst

# replication user
RUSER=replicator
RPASSWD=securityfirst

# copy mysql config
cp /vagrant/50-slave.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

sudo service mysql restart

# get MASTER_LOG_FILE, MASTER_LOG_POS
echo "Setup replication"
MASTER_LOGINFO=$(mysql -uroot -p$DBPASSWD -h$MASTERHOST -e 'SHOW MASTER STATUS' -AN)
MASTER_LOG_FILE=$(echo $MASTER_LOGINFO | awk '{print $1}')
MASTER_LOG_POS=$(echo $MASTER_LOGINFO | awk '{print $2}')

mysql -uroot -p$DBPASSWD << EOF
STOP SLAVE;
CHANGE MASTER TO MASTER_HOST = '$MASTERHOST', MASTER_USER = '$RUSER', MASTER_PASSWORD = '$RPASSWD', MASTER_LOG_FILE = '$MASTER_LOG_FILE', MASTER_LOG_POS = $MASTER_LOG_POS;
START SLAVE;
EOF

# test replication (Master side)
echo "Create database on master"
mysql -uroot -p$DBPASSWD -h$MASTERHOST -e "CREATE DATABASE $DBNAME;"
echo "Create table on master"
mysql -uroot -p$DBPASSWD -h$MASTERHOST << EOF
USE $DBNAME;
CREATE TABLE replica (id int, name varchar(20), surname varchar(20));
INSERT INTO replica VALUES (1, 'Linus', 'Torvalds');
INSERT INTO replica VALUES (2, 'Richard', 'Stallman');
EOF

# test replication (Slave side)
echo "Test replication:"
mysql -uroot -p$DBPASSWD -e "USE $DBNAME; SELECT * FROM replica;"
