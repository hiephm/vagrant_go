#!/bin/sh
# Only run this script AFTER adding new vdi drive
DEVICE=$1
MOUNT_FOLDER=$2

if [ $# -lt 2 ]; then
	echo "Usage: $0 {device} {mount folder}"
	exit
fi

if [ -b "/dev/${DEVICE}" ]; then
    if [ -b "/dev/${DEVICE}1" ]; then
        echo "The partition already created, ignore fdisk"
    else    
        echo "==> Creating new partition..."
        fdisk /dev/${DEVICE} <<EOL
n
p
1


w
EOL

		echo "==> Formatting partition..."
		mkfs.ext4 /dev/${DEVICE}1
    fi
else
    echo "You must create new disk and attach to this VM"
    exit
fi

if [ -b "/dev/${DEVICE}1" ]; then
    echo "==> Mounting new partition..."
    mkdir -p ${MOUNT_FOLDER}
    echo "" >> /etc/fstab
    echo "/dev/${DEVICE}1 ${MOUNT_FOLDER} ext4 defaults 0 2" >> /etc/fstab
    mount -a

    echo "==> All done."
else
    echo "/dev/${DEVICE}1 is not exist. Likely that there is error in running fdisk"
fi
