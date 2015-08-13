#!/bin/bash

# Title: Java thread dump

# Description:  leverages jstack to create java thread dumps.  This script will also remove
# older thread dumps based on how many days is configured in the 'RETENTION_DAYS' variable.
# Execute this as the user that's running the java process

# Author: Tony Welder
# Email:  tony.wvoip@gmail.com

##CONFIGURATION##
LOG_DIRECTORY="/var/log/thread_dumps/"
RETENTION_DAYS="7"
DUMP_MODE='744'
PROCESS="tomcat-juli"

##COMMANDS##
JSTACK="/usr/bin/jstack"
LS="/bin/ls"
AWK="/bin/awk"
GREP="/bin/grep"
CHMOD="/bin/chmod"
MKDIR="/bin/mkdir"
ECHO="/bin/echo"
DATE="/bin/date"
PS="/bin/ps"
FIND='/bin/find'

##VARIABLES##
CURRENT_DATE=`$DATE +'%m-%d-%y_%T'`
MONTH_DAY_YEAR=`$ECHO $CURRENT_DATE | $AWK -F '_' '{print $1}'`

#check if LOG_DIRECTORY exists
if [ ! -d "$LOG_DIRECTORY" ]; then
  $ECHO "Create ${LOG_DIRECTORY} and set the permissions so the user executing the dump can write to this directory"
  $ECHO "Failed to take a dump :)"
  exit 1
fi

#create sub directory for this day's dumps
if [ ! -d "${LOG_DIRECTORY}/${MONTH_DAY_YEAR}" ]; then
  $MKDIR ${LOG_DIRECTORY}/${MONTH_DAY_YEAR}
  $CHMOD 755 ${LOG_DIRECTORY}/${MONTH_DAY_YEAR}
fi

#take the dump
PID=`$PS auxww | $GREP $PROCESS | $GREP -v $GREP |$AWK '{print $2}'`

if [ -z "$PID" ]; then
  $ECHO "Failed to find any java process with '${PROCESS}' in its name"
  $ECHO "Failed to take a dump :)"
  exit 1
fi

$JSTACK -F $PID > ${LOG_DIRECTORY}/${MONTH_DAY_YEAR}/thread_dump_${CURRENT_DATE}
$CHMOD $DUMP_MODE ${LOG_DIRECTORY}/${MONTH_DAY_YEAR}/thread_dump_${CURRENT_DATE}

#Clean up older dumps
$FIND $LOG_DIRECTORY -type d -ctime +${RETENTION_DAYS} -exec -rf {} \;
