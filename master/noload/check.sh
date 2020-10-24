#!/bin/bash

memfree=`cat /proc/meminfo | grep MemFree | awk '{print $2}'`;
tostop=3000000

if [ "$memfree" -lt "$tostop" ];
then
  echo 'Good shape';
else
  echo 'Bad shape';
  /sbin/shutdown -r now
fi