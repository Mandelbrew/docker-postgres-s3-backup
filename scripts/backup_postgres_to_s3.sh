#!/usr/bin/env sh

set -e

# Sanity check

if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
	echo "You need to set the AWS_ACCESS_KEY_ID environment variable."
	exit 1
fi

if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
	echo "You need to set the AWS_SECRET_ACCESS_KEY environment variable."
	exit 1
fi

if [ -z "${AWS_S3_BUCKET}" ]; then
	echo "You need to set the AWS_S3_BUCKET environment variable."
	exit 1
fi

if [ -z "${AWS_DEFAULT_REGION}" ]; then
	echo "You need to set the AWS_DEFAULT_REGION environment variable."
	exit 1
fi

if [ -z "${AWS_S3_PATH}" ]; then
	echo "You need to set the AWS_S3_PATH environment variable."
	exit 1
fi

if [ -z "${AWS_S3_ENDPOINT}" ]; then
	AWS_ARGS=""
else
	AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

if [ "${AWS_S3_S3V4}" = "yes" ]; then
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

# Prep env

export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} ${POSTGRES_EXTRA_OPTS}"
TMP_DUMP_FILE=dump.sql.gz
AWS_TARGET="s3://${AWS_S3_BUCKET}${AWS_S3_PATH}${POSTGRES_DATABASE}_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz"

# Do it

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."
pg_dump ${POSTGRES_HOST_OPTS} ${POSTGRES_DATABASE} | gzip >${TMP_DUMP_FILE}

echo "Uploading dump to ${AWS_S3_BUCKET}"
aws ${AWS_ARGS} s3 cp ${TMP_DUMP_FILE} ${AWS_TARGET} || exit 2

echo "SQL backup uploaded successfully"