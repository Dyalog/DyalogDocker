#!/bin/bash

if ! [ -d /MiServer ]; then
    git clone https://github.com/Dyalog/MiServer.git /MiServer
else
    cd /MiServer
    git pull
fi

export MiServer=${MiServer-/MiServer/MS3}
dyalog -s /MiServer/miserver.dws

