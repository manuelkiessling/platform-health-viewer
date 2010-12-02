#!/bin/bash
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 24-29`&event[source]=$2&event[name]=cpu_usr_percentage"    $1queue_event
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 34-39`&event[source]=$2&event[name]=cpu_nice_percentage"   $1queue_event
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 44-49`&event[source]=$2&event[name]=cpu_sys_percentage"    $1queue_event
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 54-59`&event[source]=$2&event[name]=cpu_iowait_percentage" $1queue_event
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 64-69`&event[source]=$2&event[name]=cpu_steal_percentage"  $1queue_event
curl --silent --data "event[value]=`sar 1 1| grep Average| cut -b 74-79`&event[source]=$2&event[name]=cpu_idle_percentage"   $1queue_event
