#!/bin/sh

sleep 5 &
chars="/-\|"
while [ "$(ps -ef | grep sleep\ 5 | wc -l | awk '{print $1}')" -ne "1" ]; do
  for (( i=0; i<${#chars}; i++ )); do
    sleep 0.5
    printf "processing ... %s\r" "${chars:$i:1}"
  done
done
