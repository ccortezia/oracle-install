#!/usr/bin/env bash

# --------------------------------------------------------------------------------------------------------------------
# Oracle download urls:
#  
#  Instant Client
#  http://download.oracle.com/otn/linux/instantclient/11203/oracle-instantclient11.2-basic-11.2.0.3.0-1.x86_64.rpm
#
#  Oracle-Ex-11gR2
#  http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip
#
# --------------------------------------------------------------------------------------------------------------------

set -e

TMP=/tmp
ORACLE_SERVER_ZIP=oracle-xe-11.2.0-1.0.x86_64.rpm.zip
ORACLE_SERVER_RPM=oracle-xe-11.2.0-1.0.x86_64.rpm 
ORACLE_SERVER_DEB=oracle-xe_11.2.0-2_amd64.deb
ORACLE_CLIENT_RPM=oracle-instantclient11.2-basic-11.2.0.3.0-1.x86_64.rpm
ORACLE_CLIENT_DEB=oracle-instantclient11.2-basic_11.2.0.3.0-2_amd64.deb


#apt-get update

#yes | apt-get install unzip
#yes | apt-get install alien
#yes | apt-get install bc 
#yes | apt-get install unixodbc
#yes | apt-get install libaio1

# Fix awk
ln -sf /usr/bin/awk /bin/awk

# Mount memory dir
bash shm.sh 2> /dev/null

# 2G swap partition
bash swap.sh > /dev/null

# Oracle 11gR2 XE requires additional kernel parameters
cp 60-oracle.conf /etc/sysctl.d/60-oracle.conf 
sudo service procps start 

# Fix filesystem
mkdir -p /var/lock/subsys 
touch /var/lock/subsys/listener

cp chkconfig /sbin/chkconfig
chmod +x /sbin/chkconfig


# Produce .deb's
rm -rf Disk1
if [ ! -f ${ORACLE_SERVER_DEB} ]; then
    unzip ${ORACLE_SERVER_ZIP}
    alien --scripts Disk1/${ORACLE_SERVER_RPM}
fi
if [ ! -f ${ORACLE_CLIENT_DEB} ]; then
    alien --scripts ${ORACLE_CLIENT_RPM}
fi

# Install
dpkg --get-selections | grep oracle-xe || dpkg -i ${ORACLE_SERVER_DEB}
odpkg --get-selections | grep racle-instantclient || dpkg -i ${ORACLE_CLIENT_DEB}

# Configure
sudo service oracle-xe stop 2>/dev/null
/etc/init.d/oracle-xe configure

# Oracle env
cat bashrc >> ~/.bashrc
. ~/.profile

# Cleanup
rm /sbin/chkconfig
rm -rf Disk1



