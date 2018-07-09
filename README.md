# Backup mysql databases with docker

Backup mysql databases periodically (using cron rule)

## Usage

**Docker command:**

```bash
docker run --name=backup-mysql \
  --restart=always \
  -v <path_to_backup_output>:/output \
  -v /etc/localtime:/etc/localtime:ro \
  --link mysql:mysql \
  -e CRON_SCHEDULE='0 2 * * *' \
  -e KEEP_FILES_UNTIL=30 \
  -e MYSQL_HOST=mysql \
  -e MYSQL_PORT=3306 \
  -e MYSQL_USER=<mysql_user> \
  -e MYSQL_PASSWORD=<mysql_password> \
  -e SKIP_DATABASES='information_schema performance_schema sys' \
  -d humpedli/docker-mysql-backup
```

---
**Docker compose:**

```bash
version: '3'
services:
  backup-mysql:
    container_name: "backup-mysql"
    image: "humpedli/docker-mysql-backup"
    volumes:
      - "<path_to_backup_output>:/output"
      - "/etc/localtime:/etc/localtime:ro"
    environment:
      - "CRON_SCHEDULE=0 2 * * *"
      - "KEEP_FILES_UNTIL=30"
      - "MYSQL_HOST=mysql"
      - "MYSQL_PORT=3306"
      - "MYSQL_USER=<mysql_user>"
      - "MYSQL_PASSWORD=<mysql_password>"
      - "SKIP_DATABASES=information_schema performance_schema sys"
    depends_on:
      - mysql
    restart: "always"
```

## Note

*You can skip databases from backup if you define `SKIP_DATABASES=` environment variable and put database names after it (with space separator), default: `information_schema performance_schema sys`*

*Define `KEEP_FILES_UNTIL=` environment variable to delete files after x days automatically, default: `30`*