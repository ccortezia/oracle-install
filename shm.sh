#!/bin/bash

# Fix memory mount for oracle
# -----------------------------------------------------------

sudo umount /dev/shm 
sudo rm -rf /dev/shm 
sudo mkdir -p /dev/shm 
sudo mount -t tmpfs shmfs -o size=512m /dev/shm


# Make reboot persistent
# -----------------------------------------------------------
exec >& /etc/rc2.d/S01shm_load
echo #!/bin/sh
echo 'case "$1" in'
echo 'start) mkdir /var/lock/subsys 2>/dev/null'
echo '      touch /var/lock/subsys/listener'
echo '      rm /dev/shm 2>/dev/null'
echo '      mkdir /dev/shm 2>/dev/null'
echo '      mount -t tmpfs shmfs -o size=512m /dev/shm ;;'
echo '*) echo error'
echo '   exit 1 ;;'
echo 'esac'
exec

chmod 755 /etc/rc2.d/S01shm_load
