#!/usr/bin/env bash

# initialize variables
DBHOST=%
DBNAME=TESTBASE
DBUSER=user
DBPASSWD=securityfirst

#  prepare installation
if [ ! -f /var/log/setup_done ]
then
    apt-get update

    debconf-set-selections <<< "mariadb-server mysql-server/root_password password $DBPASSWD"
    debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password $DBPASSWD"

    # install mysql
    apt-get -y install mariadb-server mariadb-client

    # create user and grant access
    mysql -uroot -p$DBPASSWD -e "CREATE USER '$DBUSER'@'$DBHOST' IDENTIFIED BY '$DBPASSWD';GRANT ALL ON *.* TO '$DBUSER'@'$DBHOST';FLUSH PRIVILEGES;"

    # Set up root user's host to be accessible from any remote
    mysql -uroot -p$DBPASSWD -e "CREATE USER 'root'@'%' IDENTIFIED BY '$DBPASSWD'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
    mysql -uroot -p$DBPASSWD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$DBPASSWD';"
    # mysql -uroot -p$DBPASSWD -e "USE mysql; UPDATE user SET Host='%' WHERE User='root' AND Host='localhost'; DELETE FROM user WHERE Host != '%' AND User='root'; FLUSH PRIVILEGES;"

    touch /var/log/setup_done
fi