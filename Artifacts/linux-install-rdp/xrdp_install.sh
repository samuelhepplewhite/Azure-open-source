#!/bin/bash

# script to install Java on Ubuntu (APT) systems or YUM-based systems.
# 
# Update the package system prior to installing Java to ensure we can get what we need.
#
# Version 0.1
# Author Samuel Hepplewhite

echo "Installing xRDP"

isApt=`command -v apt-get`
isYum=`command -v yum`

# Some of the previous commands will fail with an exit code other than zero (intentionally), 
# so we do not set error handling to stop (set e) until after they've run
set -e

if [ -n "$isApt" ] ; then
    echo "Using APT package manager"

    sudo apt-get -y update
    
    sudo apt-get -y install xrdp

    sudo apt-get -y install mate-core mate-desktop-environment mate-notification-daemon

    sudo sed -i.bak '/fi/a #xrdp multiple users configuration \n mate-session \n' /etc/xrdp/startwm.sh

    sudo ufw allow 3389

    exit 0
elif [ -n "$isYum" ] ; then
    echo "Using YUM package manager"

    yum -y update
    yum clean all
    
    yum -y install epel-release

    yum -y install xrdp tigervnc-server

    systemctl start xrdp

    systemctl enable xrdp

    firewall-cmd --permanent --add-port=3389/tcp
    firewall-cmd --reload

    chcon --type=bin_t /usr/sbin/xrdp
    chcon --type=bin_t /usr/sbin/xrdp-sesman

    exit 0
fi

exit 1