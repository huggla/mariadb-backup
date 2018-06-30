**Note! I use Docker latest tag for development, which means that it isn't allways working. Date tags are stable.**

# mariadb-backup
A light and simple Docker image for backing up Mariadb/Mysql. It runs mysqldump from Mariadb 10.3.7 on Alpine Linux.

## Environment variables
### pre-set runtime variables
* VAR_LINUX_USER (mysql): The Linux/database user that performs the backup.
* VAR_FINAL_COMMAND (/usr/sbin/crond -f -d 8): Backups are initiated by crond.
* VAR_BACKUP_DIR (/backup): Where the backups will be created.
* VAR_PORT (3306): Database port.
* VAR_DELETE_DUPLICATES (yes): Duplicate files will be deleted from previous backup.

### Other runtime variables
* VAR_HOST: The database host.
* VAR_DATABASES: Comma separated list of databases to back up.
* VAR_DROP: Set to "yes" to add drop triggers to the backup.
* VAR_&lt;database from VAR_DATABASES&gt;_drop: Like VAR_DROP, but limited to named database.
* VAR_&lt;database from VAR_DATABASES&gt;_excludetables: Tables in named database that should not be backed up.
* VAR_&lt;database from VAR_DATABASES&gt;_tables: Limit back up to these tables in named database.
* VAR_&lt;name&gt;: Name of backup cron job.
* VAR_cron_&lt;name&gt;: When to run backups of named job.

## Cron examples
>VAR_weekdays="/bin/date +%a"  
VAR_cron_weekdays="0 21 \* \* 1-5"

>VAR_weekly="(( $(/bin/date +%d) + 6 ) / 7)"  
VAR_cron_weekly="0 19 \* \* 5"

>VAR_monthly="/bin/date +%b"  
VAR_cron_monthly="0 17 1 * *"

## Capabilities
Can drop all but CHOWN, FOWNER, SETGID and SETUID.
