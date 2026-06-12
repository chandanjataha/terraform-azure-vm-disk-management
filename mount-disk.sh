#!/bin/bash

parted /dev/sdc --script mklabel gpt
parted /dev/sdc --script mkpart primary ext4 0% 100%
mkfs.ext4 /dev/sdc1
mkdir -p /data
mount /dev/sdc1 /data
echo "/dev/sdc1 /data ext4 defaults,nofail 0 2" >> /etc/fstab
