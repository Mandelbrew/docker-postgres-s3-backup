#!/usr/bin/env sh

set -ef
# set -x # Debug mode

# Prep env
IFS=$(echo -en "\n\b")
CRONTAB=/etc/crontabs/root
TASK_PREFIX='POSTGRES_CRON_TASK_'

# Sanity check
if [ -z $(printenv | grep ${TASK_PREFIX}) ]; then
    # Run once
    ./backup_postgres_to_s3.sh
    exit 0;
fi

# Parse custom tasks
echo "# Custom tasks" >>${CRONTAB}
for task in $(printenv | grep ${TASK_PREFIX} | cut -d= -f2); do
    echo ${task} >>${CRONTAB}
done
echo "# An empty line is required at the end of this file for a valid cron file." >>${CRONTAB}

# Start service
crond -f -l 0

