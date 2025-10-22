#!/bin/bash

set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ $(ls -A "/var/lib/mysql" | wc -l) -eq 0 ]; then
  
  echo "First run -- initializing database!"

  mysql_install_db --user=mysql --datadir=/var/lib/mysql

  mysqld_safe --user=mysql --datadir=/var/lib/mysql &

  sleep 10

  echo "Setting root password..."
  
  mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
  
  #For security
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "DELETE FROM mysql.user WHERE User='';"
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "DROP DATABASE IF EXISTS test;"
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

  echo "Creating Database for wordpress..."

  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${MYSQL_DATABASE}"

  echo "Creating USER for wordpress..."

  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
  echo "Stopping temporary MariaDB..."

  mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown
  
  sleep 5
fi


echo "Starting Mariadb server..."
exec mysqld --user=mysql --datadir=/var/lib/mysql