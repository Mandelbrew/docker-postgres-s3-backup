#!/bin/sh bash

set -e

if [ -z "${SCHEDULE}" ]; then
    echo "You need to set the SCHEDULE environment variable."
    exit 1
fi

# Make env var available for cron jobs
printenv | grep -v "no_proxy" >>/etc/environment

echo "${SCHEDULE} root sh /backup.sh >>/var/log/cron.log 2>&1" >>/etc/crontab
echo "# An empty line is required at the end of this file for a valid cron file." >>/etc/crontab

echo "starting cron service..." >>/var/log/cron.log
service cron start
tail -f /var/log/cron.log
