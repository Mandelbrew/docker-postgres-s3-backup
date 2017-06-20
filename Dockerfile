FROM       postgres:9.6
MAINTAINER Carlos Avila "cavila@mandelbrew.com"

# Prep env
ENV        DEBIAN_FRONTEND        noninteractive
ENV 	   POSTGRES_DATABASE      ''
ENV        POSTGRES_HOST          ''
ENV        POSTGRES_PORT          ''
ENV        POSTGRES_USER 		  ''
ENV        POSTGRES_PASSWORD      ''
ENV        POSTGRES_EXTRA_OPTS    '-c'
ENV        S3_ACCESS_KEY_ID       ''
ENV        S3_SECRET_ACCESS_KEY   ''
ENV        S3_BUCKET              ''
ENV        S3_REGION              ''
ENV        S3_PATH                ''
ENV        S3_ENDPOINT            ''
ENV        S3_S3V4                ''
ENV        SCHEDULE               '0 0 * * *'

# Operating System
RUN        apt-get update -y \
           && apt-get install -y \
             awscli \
           && apt-get autoremove -y \
           && apt-get clean -y \
           && rm -rf /var/lib/apt/lists/* \
           && rm -rf /usr/share/man/*

ADD        scripts/backup.sh /backup.sh
ADD		   scripts/docker-cmd.sh /docker-cmd.sh

# Create the log file to be able to run tail
RUN        touch /var/log/cron.log

CMD        ["sh", "docker-cmd.sh"]