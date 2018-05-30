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

## This is a workaround for APL using 100% CPU when input is redirected from /dev/null

mkfifo /tmp/aplfifo
tail -f /dev/null > /tmp/aplfifo &

export MiServer=${MiServer-/MiServer/SampleMiSites/MS3}
dyalog -ride +s /MiServer/miserver.dws 0</tmp/aplfifo 

