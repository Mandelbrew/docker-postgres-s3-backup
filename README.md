# Supported tags and respective `Dockerfile` links

-	[`3.5` (*3.5/Dockerfile*)](https://github.com/Mandelbrew/docker-postgres-s3-backup/blob/3.5/Dockerfile)
-	[`3.6`,`latest` (*3.6/Dockerfile*)](https://github.com/Mandelbrew/docker-postgres-s3-backup/blob/3.6/Dockerfile)


# What is it?

This image provides PostgreSQL and AWS tools to automate the backup process of databases. Tags track the official 
alpine repository and the packages that come with it: 

- 3.5: alpine:3.5, postgresql-9.6.3-r0, aws-cli-1.11.116, Python-3.5.2, botocore-1.5.79
- 3.6: alpine:3.6, postgresql-9.6.3-r0, aws-cli-1.11.116, Python-3.6.1, botocore-1.5.79

# How to use this image

## Usage

Docker run once:
```sh
$ docker run \
    -e POSTGRES_DB='' \
    -e POSTGRES_HOST='' \
    -e POSTGRES_PORT='' \
    -e POSTGRES_USER='' \
    -e POSTGRES_PASSWORD='' \
    -e POSTGRES_AWS_ACCESS_KEY_ID='' \
    -e POSTGRES_AWS_SECRET_ACCESS_KEY='' \
    -e POSTGRES_AWS_S3_BUCKET='' \
    -e POSTGRES_AWS_DEFAULT_REGION='' \
    -e POSTGRES_AWS_S3_PATH=''
    mandelbrew/docker-postgres-s3-backup
```

Docker run on a schedule:
```sh
$ docker run \
    -e POSTGRES_DB='' \
    -e POSTGRES_HOST='' \
    -e POSTGRES_PORT='' \
    -e POSTGRES_USER='' \
    -e POSTGRES_PASSWORD='' \
    -e POSTGRES_AWS_ACCESS_KEY_ID='' \
    -e POSTGRES_AWS_SECRET_ACCESS_KEY='' \
    -e POSTGRES_AWS_S3_BUCKET='' \
    -e POSTGRES_AWS_DEFAULT_REGION='' \
    -e POSTGRES_AWS_S3_PATH='' \
    -e POSTGRES_CRON_TASK_1='0 0 * * * sh /opt/docker/backup_postgres_to_s3.sh'
    mandelbrew/docker-postgres-s3-backup
```

Docker Compose:
```yaml
postgres:
  image: postgres
  environment:
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password

postgres_backups:
  image: mandelbrew/docker-postgres-s3-backup
  links:
    - postgres
  environment:
    # AWS
    POSTGRES_AWS_ACCESS_KEY_ID:
    POSTGRES_AWS_DEFAULT_REGION:
    POSTGRES_AWS_S3_BUCKET:
    POSTGRES_AWS_S3_PATH:
    POSTGRES_AWS_SECRET_ACCESS_KEY:
    # DB
    POSTGRES_DB:
    POSTGRES_HOST:
    POSTGRES_PASSWORD:
    POSTGRES_PORT:
    POSTGRES_USER:
    # Schedule
    POSTGRES_CRON_TASK_1: '0 0 * * * sh /opt/docker/backup_postgres_to_s3.sh'
```

## Automatic Periodic Backups

You can additionally set the `POSTGRES_CRON_TASK_*` environment variables like `-e POSTGRES_CRON_TASK_1='0 0 * * * sh /opt/docker/backup_postgres_to_s3.sh'` to run the 
backup automatically.

More information about the scheduling can be found [here](#TODO).

# Credits

Based on Schickling's postgres-backup-s3: 

- https://github.com/schickling/dockerfiles/tree/master/postgres-backup-s3