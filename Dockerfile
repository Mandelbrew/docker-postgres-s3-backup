FROM       postgres:alpine
MAINTAINER Carlos Avila "cavila@mandelbrew.com"

# Prep env
ENV        DEBIAN_FRONTEND        noninteractive
ENV 	   POSTGRES_DATABASE      ''
ENV        POSTGRES_HOST          ''
ENV        POSTGRES_PORT          ''
ENV        POSTGRES_USER 		  ''
ENV        POSTGRES_PASSWORD      ''
ENV        POSTGRES_EXTRA_OPTS    '--format=c'
ENV        AWS_ACCESS_KEY_ID      ''
ENV        AWS_SECRET_ACCESS_KEY  ''
ENV        AWS_S3_BUCKET          ''
ENV        AWS_DEFAULT_REGION     ''
ENV        AWS_S3_PATH            ''
ENV        AWS_S3_ENDPOINT        ''
ENV        AWS_S3_S3V4            ''
ENV        CRON_TASK_1            '1 0 * * * sh /root/backup_postgres_to_s3.sh'

# Operating System
RUN        apk update \
           && apk add --no-cache \
               python3 \
               curl \
           && pip3 install --no-cache-dir --upgrade pip setuptools wheel \
           && pip3 install --no-cache-dir \
               awscli

# Application
WORKDIR	   /root

ADD        scripts/backup_postgres_to_s3.sh backup_postgres_to_s3.sh
RUN        chmod +x backup_postgres_to_s3.sh

ADD        scripts/docker-cmd.sh docker-cmd.sh
RUN        chmod +x docker-cmd.sh

CMD        ["./docker-cmd.sh"]