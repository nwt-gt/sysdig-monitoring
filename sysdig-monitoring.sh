#!/bin/bash

# Monitoring container

echo "Sysdig logging"

set -eu

date=`date +%d-%m-%Y`
echo "Logging-date: ${date}"
outputFileName=${date}_logs

containerName=$1
echo "Container to monitor: ${containerName}"



sysdig -pc -M 60 -w ${date}.scap -c spy_users container.name=${containerName} >> ${PWD}/logs/${outputFileName}

echo "${date}_Logging-complete"
echo "Removing scap to clear space"
rm ${date}.scap

# Send Email
echo "Sending mail"

attachment=${2}${date}_logs
email=$3

echo "Recipient: ${email} --------------- Attaching: ${attachment}"

echo "Logs for ${date} ----- Please check " | mutt -a ${attachment} -s "Sysdig logging ${date}" -- ${email}

echo "Mail sent"

exit 0
