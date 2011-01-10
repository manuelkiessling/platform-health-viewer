#!/bin/bash
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 14-15`&event[source]=$2&event[name]=cpu_usr_percentage"  $1queue_event
echo
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 21-22`&event[source]=$2&event[name]=cpu_nice_percentage" $1queue_event
echo
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 28-29`&event[source]=$2&event[name]=cpu_sys_percentage"  $1queue_event
echo
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 35-36`&event[source]=$2&event[name]=cpu_idle_percentage" $1queue_event
echo
