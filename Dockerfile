FROM alpine

# add cron
RUN apk add --update apk-cron

# add bash mysql client and gzip
RUN apk add bash mysql-client gzip

# clear apk cache
RUN rm -rf /var/cache/apk/*

# copy files
COPY backup.sh /bin/backup
COPY run.sh /run.sh
RUN mkdir /output
RUN chmod +x /bin/backup /run.sh

# entry point
CMD ["/run.sh"]