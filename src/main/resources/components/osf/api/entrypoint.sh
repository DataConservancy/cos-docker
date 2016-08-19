#!/bin/ash

echo "Entrypoint begin."
echo `/bin/pwd`
echo `ls -la .osf-init.dirty`

exec "$@"
