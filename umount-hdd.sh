#!/bin/bash
export PATH=/usr/bin:/bin:/usr/sbin:/sbin

MOUNTPOINT="/mnt/hdd"

logger "NAS: umount-hdd.sh → aufgerufen"

# Ist das überhaupt gemountet?
mountpoint -q "$MOUNTPOINT"
if [ $? -ne 0 ]; then
    logger "NAS: umount-hdd.sh → $MOUNTPOINT ist schon ungemountet."
    exit 0
fi

# Normaler Unmount
umount "$MOUNTPOINT"

if [ $? -eq 0 ]; then
    logger "NAS: umount-hdd.sh → SUCCESS (clean)."
    exit 0
else
    logger "NAS: umount-hdd.sh → normaler Unmount failed, versuche lazy..."
    umount -l "$MOUNTPOINT"
    logger "NAS: umount-hdd.sh → lazy Unmount ausgeführt."
    exit 0
fi

