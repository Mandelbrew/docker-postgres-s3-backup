#!/usr/bin/env sh

set -ef
# set -x # Debug mode

# Prep env
IFS=$(echo -en "\n\b")
CRONTAB=/etc/crontabs/root
TASK_PREFIX='POSTGRES_CRON_TASK_'

# Sanity check
if [ -z $(printenv | grep ${TASK_PREFIX}) ]; then
    echo "You need to set at least one environment variable with prefix '${TASK_PREFIX}'."
    exit 1
fi

# Parse custom tasks
echo "# Custom tasks" >>${CRONTAB}
for task in $(printenv | grep ${TASK_PREFIX} | cut -d= -f2); do
    echo ${task} >>${CRONTAB}
done
echo "# An empty line is required at the end of this file for a valid cron file." >>${CRONTAB}

# Start service
crond -f -l 0

