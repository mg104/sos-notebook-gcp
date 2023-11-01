#!/bin/bash


mkdir --parents "${MOUNT_POINT}"

gcsfuse -o allow_other --implicit-dirs  "${BUCKET_NAME}" "${MOUNT_POINT}" &

exec "$@"
