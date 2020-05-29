#!/bin/bash

# Monitoring container
echo "Sysdig logging"

set -eu

if [[ $# -ne 4 ]]; then
    echo "Wrong arguments. Call this script with:"
    echo " ${0} <containerName> <pathToAttachment> <Email> <Window>"
    exit 2;
fi


date=`date +%d-%m-%Y`
echo "Logging-date: ${date}"
outputFileName=${date}_logs

containerName=$1
attachment=${2}${outputFileName}
email=$3
window=$4
echo "Container to monitor: ${containerName} with window: ${window} seconds"

sysdig -pc -M ${window} -w ${date}.scap -c spy_users container.name=${containerName} >> ${attachment}

echo "${date}_Logging-complete"
echo "Removing scap to clear space"
rm ${date}.scap

# Send Email
echo "Sending mail"

echo "Recipient: ${email} --------------- Attaching: ${attachment}"

echo "Logs for ${date} ----- Please check " | mutt -a ${attachment} -s "Sysdig logging ${date}" -- ${email}

echo "Mail sent"

exit $?

