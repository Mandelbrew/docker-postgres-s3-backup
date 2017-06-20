#!/bin/env bash

set -e

if [ -z "${S3_ACCESS_KEY_ID}" ]; then
	echo "You need to set the S3_ACCESS_KEY_ID environment variable."
	exit 1
fi

if [ -z "${S3_SECRET_ACCESS_KEY}" ]; then
	echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
	exit 1
fi

if [ -z "${S3_BUCKET}" ]; then
	echo "You need to set the S3_BUCKET environment variable."
	exit 1
fi

if [ -z "${S3_REGION}" ]; then
	echo "You need to set the S3_REGION environment variable."
	exit 1
fi

if [ -z "${S3_PATH}" ]; then
	echo "You need to set the S3_PATH environment variable."
	exit 1
fi

if [ -z "${S3_ENDPOINT}" ]; then
	AWS_ARGS=""
else
	AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

if [ -z "${POSTGRES_DATABASE}" ]; then
	echo "You need to set the POSTGRES_DATABASE environment variable."
	exit 1
fi

if [ -z "${POSTGRES_HOST}" ]; then
	echo "You need to set the POSTGRES_HOST environment variable."
	exit 1
fi

if [ -z "${POSTGRES_PORT}" ]; then
	echo "You need to set the POSTGRES_PORT environment variable."
	exit 1
fi

if [ -z "${POSTGRES_USER}" ]; then
	echo "You need to set the POSTGRES_USER environment variable."
	exit 1
fi

if [ -z "${POSTGRES_PASSWORD}" ]; then
	echo "You need to set the POSTGRES_PASSWORD environment variable."
	exit 1
fi

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=${S3_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${S3_SECRET_ACCESS_KEY}
export AWS_DEFAULT_REGION=${S3_REGION}

export PGPASSWORD=$POSTGRES_PASSWORD

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"
pg_dump $POSTGRES_HOST_OPTS $POSTGRES_DATABASE | gzip >dump.sql.gz

echo "Uploading dump to $S3_BUCKET"

aws ${AWS_ARGS} s3 cp dump.sql.gz s3://${S3_BUCKET}${S3_PATH}${POSTGRES_DATABASE}_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz || exit 2

echo "SQL backup uploaded successfully"