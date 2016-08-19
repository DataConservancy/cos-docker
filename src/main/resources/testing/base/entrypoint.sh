#!/bin/ash

echo "hello from entrypoint!" >> /base/shared/hello-entrypoint.txt

echo "hello from entrypoint!" >> /base/local/hello-entrypoint.txt

exec "$@"
