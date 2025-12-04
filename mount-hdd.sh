#!/bin/bash
export PATH=/usr/bin:/bin:/usr/sbin:/sbin

DEVICE="/dev/sda1"
MOUNTPOINT="/mnt/hdd"

logger "NAS: mount-hdd.sh → start (waiting 5s for device readiness)"

# Critical delay — otherwise udev is too fast
sleep 5

# Warte zusätzlich, bis das Blockdevice unlocked ist
for i in {1..10}; do
    if /usr/bin/ntfsfix -n "$DEVICE" >/dev/null 2>&1; then
        break
    fi
    logger "NAS: mount-hdd.sh → Device busy, retrying..."
    sleep 1
done

mkdir -p "$MOUNTPOINT"
logger "NAS: mount-hdd.sh → versuche ntfs-3g Mount..."

 /usr/bin/ntfs-3g -o big_writes,uid=1000,gid=1000 "$DEVICE" "$MOUNTPOINT"

if [ $? -eq 0 ]; then
    logger "NAS: mount-hdd.sh → SUCCESS"
else
    logger "NAS: mount-hdd.sh → FAILED"
fi

