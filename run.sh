#!/bin/sh

# get cron schedule from ENV and copy rule to the right place
cat << EOM > /cron_rule
${CRON_SCHEDULE:-0 2 * * *} /bin/backup
0 1 * * * /usr/bin/find /output* -mtime +${KEEP_FILES_UNTIL:-30} -exec /bin/rm {} \;
EOM
cp /cron_rule /var/spool/cron/crontabs/root

# put correct environment variables into the script
sed -i "s/MYSQL_HOST=.*/MYSQL_HOST=${MYSQL_HOST:-mysql}/g" /bin/backup
sed -i "s/MYSQL_PORT=.*/MYSQL_PORT=${MYSQL_PORT:-3306}/g" /bin/backup
sed -i "s/MYSQL_USER=.*/MYSQL_USER=${MYSQL_USER:-root}/g" /bin/backup
sed -i "s/MYSQL_PASSWORD=.*/MYSQL_PASSWORD=${MYSQL_PASSWORD:-root}/g" /bin/backup
sed -i "s/SKIP_DATABASES=.*/SKIP_DATABASES='$SKIP_DATABASES'/g" /bin/backup

# start cron
/usr/sbin/crond -f -l 2
