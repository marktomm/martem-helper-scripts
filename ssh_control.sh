#!/bin/bash

while [ 1 ]; do
    ssh martem@192.168.0.111 "lsusb | wc -l"
    ssh martem@192.168.0.111 "touch /var/local/telem/reboot"
    sleep 60
done

exit 0;