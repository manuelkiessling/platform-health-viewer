#!/bin/bash

USER=`top -l 1 | grep "CPU usage"| cut -b 12-16`
SYS=`top -l 1 | grep "CPU usage"| cut -b 25-29`
IDLE=`top -l 1 | grep "CPU usage"| cut -b 36-40`

echo "http://localhost:8888/?source=macbook&name=cpu_user&value=$USER"
echo "http://localhost:8888/?source=macbook&name=cpu_sys&value=$SYS"
echo "http://localhost:8888/?source=macbook&name=cpu_idle&value=$IDLE"

curl "http://localhost:8888/?source=macbook&name=cpu_user&value=$USER"
curl "http://localhost:8888/?source=macbook&name=cpu_sys&value=$SYS"
curl "http://localhost:8888/?source=macbook&name=cpu_idle&value=$IDLE"
