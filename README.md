# docker-postgres-backup-s3
Backup PostgresSQL to S3 using a time-based scheduler

## Usage

Docker:
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
```

### Automatic Periodic Backups

You can additionally set the `POSTGRES_CRON_TASK_*` environment variables like `-e POSTGRES_CRON_TASK_1='0 0 * * * sh /opt/docker/backup_postgres_to_s3.sh'` to run the 
backup automatically.

More information about the scheduling can be found [here](#TODO).

## Credits

Based on Schickling's postgres-backup-s3: 

- https://github.com/schickling/dockerfiles/tree/master/postgres-backup-s3