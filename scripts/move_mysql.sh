#!/bin/sh
TARGET_FOLDER=$1

if [ $# -lt 1 ]; then
	echo "Usage: $0 {target folder}"
	exit
fi

if [ ! -f "${TARGET_FOLDER}" ]; then
	echo "Target folder ${TARGET_FOLDER} does not exist."
	exit
fi

if [ -e "${TARGET_FOLDER}/mysql" ]; then
	echo "mysql folder is already moved. Nothing to do"
else
	echo "==> Moving mysql folder..."
	service mysql stop
	echo "" >> /etc/mysql/mysql.conf.d/mysqld.cnf
	echo "datadir = ${TARGET_FOLDER}/mysql" >> /etc/mysql/mysql.conf.d/mysqld.cnf
	echo "tmpdir = ${TARGET_FOLDER}/tmp" >> /etc/mysql/mysql.conf.d/mysqld.cnf
	mv /var/lib/mysql ${TARGET_FOLDER}/
	mkdir -m 0777 ${TARGET_FOLDER}/tmp
	
# Hack for /usr/share/mysql/mysql-systemd-start to work
	mkdir -p /var/lib/mysql/mysql
	touch /var/lib/mysql/mysql/moved
	
	service mysql start
	echo "==> All done."
fi

