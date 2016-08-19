#!/bin/ash

# For every include file, interpolate it and then append it to the local
# settings file

for INCLUDE_FILE in `find . -name "local-docker.py.inc"` ;
do
  LOCAL_SETTINGS_FILE=`dirname $INCLUDE_FILE`/local.py
  if [ -f $LOCAL_SETTINGS_FILE ] ;
  then
    # Interpolate and append runtime environment variables to the local settings
    # file.
    echo "Interpolating ${INCLUDE_FILE} and appending it to ${LOCAL_SETTINGS_FILE}"
    cat ${INCLUDE_FILE} | envsubst >> ${LOCAL_SETTINGS_FILE}

    echo "Local settings file ${LOCAL_SETTINGS_FILE}:"
    cat ${LOCAL_SETTINGS_FILE}
    echo ""
  fi
done

echo "Executing $@"
# Execute any supplied command
exec "$@"
