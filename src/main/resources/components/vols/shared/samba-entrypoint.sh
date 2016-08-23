#!/bin/ash
#
#  Copyright 2016 Johns Hopkins University
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
chown nobody:nobody ${SHARED} && \
    chmod 4775 ${SHARED}

if [ ! -f ${SHARED}/etc/samba/smb.conf ] ; then
  echo "Creating ${SHARED}/etc/samba/smb.conf from ${SHARED}/etc/samba/smb.conf.tmpl"
  cat ${SHARED}/etc/samba/smb.conf.tmpl | envsubst > ${SHARED}/etc/samba/smb.conf
fi

/usr/sbin/smbd -D -s ${SHARED}/etc/samba/smb.conf &
/usr/sbin/nmbd -D -s ${SHARED}/etc/samba/smb.conf &

sleep 5

tail -f /var/log/samba/log.smbd
