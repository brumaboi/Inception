#!/bin/bash
set -e

if [ ! -e /etc/.firstrun ]; then
    cat >> /etc/my.cnf.d/mariadb-server.cnf << EOF

[mysqld]
bind-address=0.0.0.0
skip-networking=0
EOF
    touch /etc/.firstrun
fi

if [ ! -e /var/lib/mysql/.firstmount ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db \
        --datadir=/var/lib/mysql \
        --skip-test-db \
        --user=mysql \
        --group=mysql \
        --auth-root-authentication-method=socket >/dev/null

    mariadbd --user=mysql --datadir=/var/lib/mysql &
    pid=$!

    until mariadb-admin ping -u root --silent >/dev/null 2>&1; do
        sleep 1
    done

    mariadb --protocol=socket -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$pid"

    touch /var/lib/mysql/.firstmount
fi
chown -R mysql:mysql /var/lib/mysql /run/mysqld

exec mariadbd --user=mysql --datadir=/var/lib/mysql