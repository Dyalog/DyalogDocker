#!/bin/bash

if ! dpkg -s dyalog-unicode-150 | grep "install ok installed"; then
    DYALOG_URL=https://my.dyalog.com/files/installs/linux_64_${APL_VERSION}_unicode.zip

    cd /tmp
    wget --user="${MYDYALOG_USERNAME}" --password="${MYDYALOG_PASSWORD}" ${DYALOG_URL}
    unzip linux_64_${APL_VERSION}_unicode.zip
    dpkg -i ./linux_64_${APL_VERSION}*.deb

fi


if ! [ -d /MiServer ]; then
    git clone https://github.com/Dyalog/MiServer.git /MiServer
else
    cd /MiServer
    git pull
fi


MiServer=/MiServer/SampleMiSites/MS3 dyalog -ride +s 0</dev/null 1>/tmp/apl 2>&1 /MiServer/miserver.dws

