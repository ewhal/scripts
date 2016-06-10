#!/bin/bash

#Dependancies
#crontab
#mariadb
#sendmail

#cron backup script
#chmod +x script.sh
#crontab -e
#0 0 * * 0 ./path-to-script >> /root/log.txt 2>&1

#Database username
USERNAME=""
#database password
PASSWORD=""
#database name
DB_NAME="wordpressdb"
#Host
HOST="localhost"
#Date format
DATE=$(date +%Y-%m-%d)
#Email address to send the backups to
EMAIL=""
#Backup directory tmp
DIRECTORY="/tmp/backup"
FILE="/tmp/backup-"$DATE".zip"

#Setup and checks
if [ ! -f "/root/dropbox_uploader.sh" ]; then
    wget https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh
    chmod +x dropbox_uploader.sh
    echo "Please run dropbox_uploader.sh then run this script again"
    exit 0
fi

if [ -f "$FILE" ]; then
    rm "$FILE"
fi

if [ -d "$DIRECTORY" ]; then
    rm -rf "$DIRECTORY"
fi

if [ -d "/tmp/backup-"$DATE".zip" ]; then
    rm -rf "/tmp/backup-"$DATE".zip"
fi

#Make new directory
mkdir "$DIRECTORY"

#Dump Wordpress SQL database to file
mysqldump --add-drop-table --user="$USERNAME" --password="$PASSWORD" --host="$HOST" "$DB_NAME" > "$DIRECTORY/backup.sql"

#copy directories to backup
cp -r "/etc/nginx" "$DIRECTORY"
cp -r "/usr/share/nginx/html" "$DIRECTORY"
cp "/etc/php.ini" "$DIRECTORY"

#zip $DIRECTORY
zip -r "$FILE" "$DIRECTORY"

#upload backup.zip dropbox
sh /root/dropbox_uploader.sh upload "$FILE" /

#Delete backup directory and zip
rm -rf "$DIRECTORY" "$FILE"
