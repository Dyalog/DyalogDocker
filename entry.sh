#!/bin/bash

if ! [ -d /MiServer ]; then
    git clone https://github.com/Dyalog/MiServer.git /MiServer
else
    cd /MiServer
    git pull
fi

export MiServer=${MiServer-/MiServer/SampleMiSites/MS3}
dyalog -ride +s /MiServer/miserver.dws 0</tmp/aplfifo 

