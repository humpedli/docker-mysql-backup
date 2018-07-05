#!/bin/bash

# mysql data
MYSQL_HOST=mysql
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=root

# skip these databases from backup
SKIP_DATABASES=

# backup destination directory
DEST="/output"

# binary paths, autodetected via which command
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"

# get current date in yyyy-mm-dd format
NOW="$(date +"%Y-%m-%d")"

# get all database list
DBS="$($MYSQL -u $MYSQL_USER -h $MYSQL_HOST -P $MYSQL_PORT -p$MYSQL_PASSWORD -Bse 'show databases')"

# iterate over databases and dump them
for db in $DBS
do
    skipdb=-1
    if [ "$SKIP_DATABASES" != "" ];
    then
        for i in $SKIP_DATABASES
        do
            [ "$db" == "$i" ] && skipdb=1 || :
        done
    fi

    if [ "$skipdb" == "-1" ] ; then
        FILE="$DEST/$db.$NOW.gz"
        $MYSQLDUMP -u $MYSQL_USER -h $MYSQL_HOST -P $MYSQL_PORT -p$MYSQL_PASSWORD $db | $GZIP -9 > $FILE
    fi
done