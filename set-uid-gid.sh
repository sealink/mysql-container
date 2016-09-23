#!/bin/bash

VOLUME_PATH=/var/lib/mysql

MYSQL_UID=$(stat -c%u "$VOLUME_PATH")
MYSQL_GID=$(stat -c%g "$VOLUME_PATH")

if [ $MYSQL_UID -eq 0 ] && [ $MYSQL_GID -eq 0 ]; then
  exec /entrypoint.sh "$@"
fi

if [ $MYSQL_UID -eq 0 ] || [ $MYSQL_GID -eq 0 ]; then
  >&2 echo "$VOLUME_PATH" must be mounted with non-root permissions
  >&2 echo Unless you are using Docker for Mac
  exit 1
fi

echo Set UID if needed.
if [ $MYSQL_UID != $(id -u mysql) ]; then
  usermod -u$MYSQL_UID mysql
  if [ $? -ne 0 ]; then
    >&2 echo UID "$MYSQL_UID" is occupied
    exit 1
  fi
fi

echo Set GID if needed.
ORIGINAL_GID=$(id -g mysql)

if [ $MYSQL_GID != $ORIGINAL_GID ]; then
  getent group $MYSQL_GID
  if [ $? -eq 0 ]; then
    usermod -g $MYSQL_GID mysql
    usermod -a -G$ORIGINAL_GID mysql
  else
    groupmod -g$MYSQL_GID mysql
  fi
fi

echo "Synchronise the directory's permission."
chown -vR mysql: /var/run/mysqld

exec /entrypoint.sh "$@"
