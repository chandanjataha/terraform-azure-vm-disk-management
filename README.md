# terraform-azure-vm-disk-management

## Overview

This repository demonstrates Azure VM disk management by inspecting and preparing an attached disk on a Linux VM.

## Prerequisites

- An Azure VM with an additional attached disk (for example `/dev/sdc`).
- SSH access to the VM as a user with sudo privileges.
- `parted`, `lsblk`, and `mkfs.ext4` available on the VM.

## Step 1: Connect to the VM

SSH into the Azure VM using the target IP address:

```bash
ssh azureuser@20.16.139.36
```

If prompted for a password, provide the correct credential.

## Step 2: Check filesystem and memory status

Inspect disk usage:

```bash
df -h
```

Inspect memory usage:

```bash
free
free -m
```

## Step 3: List block devices

Identify attached disks and partitions:

```bash
lsblk
```

This shows disks such as `/dev/sda`, `/dev/sdb`, and the additional disk `/dev/sdc`.

## Step 4: Inspect the disk partition table

Use the partition table utility:

```bash
sudo fdisk -l
```

This confirms disk device details and existing partitions.

## Step 5: Partition the new disk

Create a GPT partition table on `/dev/sdc` and add a primary partition:

```bash
sudo parted /dev/sdc --script mklabel gpt
sudo parted /dev/sdc --script mkpart primary ext4 0% 100%
```

If permission is denied, ensure you are running the commands with root or sudo privileges.

## Step 6: Format the new partition

Format the new partition as `ext4`:

```bash
sudo mkfs.ext4 /dev/sdc1
```

## Step 7: Mount and verify the new filesystem

Create a mount point and mount the partition:

```bash
sudo mkdir -p /data
sudo mount /dev/sdc1 /data
```

Verify the mounted disk and partitions:

```bash
lsblk
```

Confirm the mounted filesystem with:

```bash
df -h
```

## Notes

- If SSH authentication fails, double-check the username, IP address, and password.
- The repository shows the workflow for disk inspection, partitioning, formatting, and mounting on an Azure Linux VM.


Reference logs:



azureuser@demo-vm:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        29G  1.7G   28G   6% /
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           1.6G  1.1M  1.6G   1% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/sdb15      105M  6.1M   99M   6% /boot/efi
/dev/sda1        16G   28K   15G   1% /mnt
tmpfs           795M  4.0K  795M   1% /run/user/1000
azureuser@demo-vm:~$ free
               total        used        free      shared  buff/cache   available
Mem:         8135192      306240     7313348        4172      515604     7575552
Swap:              0           0           0
azureuser@demo-vm:~$ free -m
               total        used        free      shared  buff/cache   available
Mem:            7944         288        7152           4         503        7409
Swap:              0           0           0
azureuser@demo-vm:~$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0     7:0    0 63.8M  1 loop /snap/core20/2866
loop1     7:1    0 91.7M  1 loop /snap/lxd/38800
loop2     7:2    0 49.3M  1 loop /snap/snapd/26865
sda       8:0    0   16G  0 disk 
└─sda1    8:1    0   16G  0 part /mnt
sdb       8:16   0   30G  0 disk 
├─sdb1    8:17   0 29.9G  0 part /
├─sdb14   8:30   0    4M  0 part 
└─sdb15   8:31   0  106M  0 part /boot/efi
sdc       8:32   0    5G  0 disk 
sr0      11:0    1  628K  0 rom  
azureuser@demo-vm:~$ sudo fdisk -l
Disk /dev/loop0: 63.78 MiB, 66879488 bytes, 130624 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop1: 91.68 MiB, 96129024 bytes, 187752 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop2: 49.26 MiB, 51654656 bytes, 100888 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 16 GiB, 17179869184 bytes, 33554432 sectors
Disk model: Virtual Disk    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x7e4a7dc4

Device     Boot Start      End  Sectors Size Id Type
/dev/sda1        2048 33552383 33550336  16G  7 HPFS/NTFS/exFAT


Disk /dev/sdb: 30 GiB, 32213303296 bytes, 62916608 sectors
Disk model: Virtual Disk    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: DDF27E09-E1FA-4DA0-BAD2-BBD355E03ED0

Device      Start      End  Sectors  Size Type
/dev/sdb1  227328 62916574 62689247 29.9G Linux filesystem
/dev/sdb14   2048    10239     8192    4M BIOS boot
/dev/sdb15  10240   227327   217088  106M EFI System

Partition table entries are not in disk order.


Disk /dev/sdc: 5 GiB, 5368709120 bytes, 10485760 sectors
Disk model: Virtual Disk    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
azureuser@demo-vm:~$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0     7:0    0 63.8M  1 loop /snap/core20/2866
loop1     7:1    0 91.7M  1 loop /snap/lxd/38800
loop2     7:2    0 49.3M  1 loop /snap/snapd/26865
sda       8:0    0   16G  0 disk 
└─sda1    8:1    0   16G  0 part /mnt
sdb       8:16   0   30G  0 disk 
├─sdb1    8:17   0 29.9G  0 part /
├─sdb14   8:30   0    4M  0 part 
└─sdb15   8:31   0  106M  0 part /boot/efi
sdc       8:32   0    5G  0 disk 
sr0      11:0    1  628K  0 rom  
azureuser@demo-vm:~$ client_loop: send disconnect: Connection reset
PS C:\Users\chand\OneDrive\Desktop\t> sudo parted /dev/sdc --script mklabel gpt
Sudo is disabled on this machine. To enable it, go to the Developer Settings page in the Settings app
PS C:\Users\chand\OneDrive\Desktop\t> 
PS C:\Users\chand\OneDrive\Desktop\t> 
PS C:\Users\chand\OneDrive\Desktop\t> 
PS C:\Users\chand\OneDrive\Desktop\t> ssh azureuser@20.16.139.36               
azureuser@20.16.139.36's password: 
PS C:\Users\chand\OneDrive\Desktop\t> ssh azureuser@20.16.139.36
azureuser@20.16.139.36's password: 
Permission denied, please try again.
azureuser@20.16.139.36's password: 
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1059-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Jun 12 08:06:23 UTC 2026

  System load:  0.0               Processes:             122
  Usage of /:   6.4% of 28.89GB   Users logged in:       0
  Memory usage: 3%                IPv4 address for eth0: 10.0.1.4
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

New release '24.04.4 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Fri Jun 12 05:04:16 2026 from 223.233.71.56
azureuser@demo-vm:~$ 
azureuser@demo-vm:~$ 
azureuser@demo-vm:~$ ls -lrth
total 0
azureuser@demo-vm:~$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0     7:0    0 63.8M  1 loop /snap/core20/2866
loop1     7:1    0 91.7M  1 loop /snap/lxd/38800
loop2     7:2    0 49.3M  1 loop /snap/snapd/26865
sda       8:0    0   16G  0 disk 
└─sda1    8:1    0   16G  0 part /mnt
sdb       8:16   0   30G  0 disk 
├─sdb1    8:17   0 29.9G  0 part /
├─sdb14   8:30   0    4M  0 part 
└─sdb15   8:31   0  106M  0 part /boot/efi
sdc       8:32   0    5G  0 disk 
sr0      11:0    1  628K  0 rom  
azureuser@demo-vm:~$ parted /dev/sdc --script mklabel gpt
Error: Error opening /dev/sdc: Permission denied
azureuser@demo-vm:~$ sudo -i
root@demo-vm:~# parted /dev/sdc --script mklabel gpt
root@demo-vm:~# arted /dev/sdc --script mkpart primary ext4 0% 100%
Command 'arted' not found, did you mean:
  command 'parted' from deb parted (3.4-2build1)
  command 'orted' from deb openmpi-bin (4.1.2-2ubuntu1)
Try: apt install <deb name>
root@demo-vm:~# parted /dev/sdc --script mkpart primary ext4 0% 100%
root@demo-vm:~# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0     7:0    0 63.8M  1 loop /snap/core20/2866
loop1     7:1    0 91.7M  1 loop /snap/lxd/38800
loop2     7:2    0 49.3M  1 loop /snap/snapd/26865
sda       8:0    0   16G  0 disk 
└─sda1    8:1    0   16G  0 part /mnt
sdb       8:16   0   30G  0 disk 
├─sdb1    8:17   0 29.9G  0 part /
├─sdb14   8:30   0    4M  0 part 
└─sdb15   8:31   0  106M  0 part /boot/efi
sdc       8:32   0    5G  0 disk 
└─sdc1    8:33   0    5G  0 part 
sr0      11:0    1  628K  0 rom  
root@demo-vm:~# mkfs.ext4 /dev/sdc1
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done                            
Creating filesystem with 1310208 4k blocks and 327680 inodes
Filesystem UUID: 0a4c34d2-9049-4815-bc7f-cba50b9e1d9e
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

root@demo-vm:~# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0     7:0    0 63.8M  1 loop /snap/core20/2866
loop1     7:1    0 91.7M  1 loop /snap/lxd/38800
loop2     7:2    0 49.3M  1 loop /snap/snapd/26865
sda       8:0    0   16G  0 disk 
└─sda1    8:1    0   16G  0 part /mnt
sdb       8:16   0   30G  0 disk 
├─sdb1    8:17   0 29.9G  0 part /
├─sdb14   8:30   0    4M  0 part 
└─sdb15   8:31   0  106M  0 part /boot/efi
sdc       8:32   0    5G  0 disk 
└─sdc1    8:33   0    5G  0 part 
sr0      11:0    1  628K  0 rom  
root@demo-vm:~# mkdir /data
root@demo-vm:~# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0     7:0    0 63.8M  1 loop /snap/core20/2866
loop1     7:1    0 91.7M  1 loop /snap/lxd/38800
loop2     7:2    0 49.3M  1 loop /snap/snapd/26865
sda       8:0    0   16G  0 disk 
└─sda1    8:1    0   16G  0 part /mnt
sdb       8:16   0   30G  0 disk 
├─sdb1    8:17   0 29.9G  0 part /
├─sdb14   8:30   0    4M  0 part 
└─sdb15   8:31   0  106M  0 part /boot/efi
sdc       8:32   0    5G  0 disk 
└─sdc1    8:33   0    5G  0 part 
sr0      11:0    1  628K  0 rom  
root@demo-vm:~# mount /dev/sdc1 /data
root@demo-vm:~# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0     7:0    0 63.8M  1 loop /snap/core20/2866
loop1     7:1    0 91.7M  1 loop /snap/lxd/38800
loop2     7:2    0 49.3M  1 loop /snap/snapd/26865
sda       8:0    0   16G  0 disk 
└─sda1    8:1    0   16G  0 part /mnt
sdb       8:16   0   30G  0 disk 
├─sdb1    8:17   0 29.9G  0 part /
├─sdb14   8:30   0    4M  0 part 
└─sdb15   8:31   0  106M  0 part /boot/efi
sdc       8:32   0    5G  0 disk 
└─sdc1    8:33   0    5G  0 part /data
sr0      11:0    1  628K  0 rom  
root@demo-vm:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        29G  1.9G   28G   7% /
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           1.6G  1.1M  1.6G   1% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/sdb15      105M  6.1M   99M   6% /boot/efi
/dev/sda1        16G   28K   15G   1% /mnt
tmpfs           795M  4.0K  795M   1% /run/user/1000
/dev/sdc1       4.9G   24K  4.6G   1% /data
root@demo-vm:~# blkid /dev/sdc1
/dev/sdc1: UUID="0a4c34d2-9049-4815-bc7f-cba50b9e1d9e" BLOCK_SIZE="4096" TYPE="ext4" PARTLABEL="primary" PARTUUID="4e919777-aff5-4ad3-a281-43706faf822e"
root@demo-vm:~# 