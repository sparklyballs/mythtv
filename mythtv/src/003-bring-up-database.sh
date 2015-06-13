#!/bin/bash
start_mysql(){
    /usr/bin/mysqld_safe --datadir=/config/databases > /dev/null 2>&1 &
    RET=1
    while [[ RET -ne 0 ]]; do
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
        sleep 1
    done
}

# If databases do not exist create them
if [ -f /config/databases/mysql/user.MYD ]; then
  echo "Database exists."
else
  echo "Creating database."
  /usr/bin/mysql_install_db --datadir=/db >/dev/null 2>&1
  start_mysql
  echo "Database created. Granting access to 'mythtv' ruser for all hosts."
  mysql -uroot -e "CREATE USER 'mythtv' IDENTIFIED by 'mythtv'" 
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'mythtv'@'%' WITH GRANT OPTION"
  mysql -uroot -e "CREATE DATABASE mythconverg"
  mysqladmin -u root shutdown
  chown -R nobody:users /db
  chmod -R 755 /db
fi

echo "Starting MariaDB..."
/usr/bin/supervisord -c /root/supervisor-files/db-supervisord.conf & >/dev/null 2>&1



