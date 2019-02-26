#!/bin/sh
## Visualize progress processing for template

## Main Processing
sleep 5 &

## Visualize Processing
chars="/-\|"
while [ "$(ps -ef | grep sleep\ 5 | wc -l | awk '{print $1}')" -ne "1" ]; do
  for (( i=0; i<${#chars}; i++ )); do
    sleep 0.5
    printf "processing ... %s\r" "${chars:$i:1}"
  done
done
