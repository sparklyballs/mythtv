#!/bin/bash
mkdir -p  /var/run/sshd
mkdir  -p /root/.vnc
chown -R mythtv:users /home/mythtv/
/usr/bin/supervisord -c /root/supervisor-files/rdp-supervisord.conf
while [ 1 ]; do
/bin/bash
done
