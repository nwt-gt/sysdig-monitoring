#!/bin/bash
echo "Sysdig logging"

set -eu

date=`date +%d-%m-%Y`
echo "Logging-date: ${date}"

containerName=$1
echo "Container to monitor: ${containerName}"

outputFileName=${date}_logs

sysdig -pc -M 60 -w ${date}.scap -c spy_users container.name=${containerName} >> ${PWD}/logs/${outputFileName}

echo "${date}_Logging-complete"
echo "Removing scap to clear space"
rm ${date}.scap

#echo "This is the body of the email" | mail -s "Sysdig" root

exit 0

