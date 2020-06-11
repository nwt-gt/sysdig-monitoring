#!/bin/bash

# Monitoring container
echo "Sysdig logging"

set -eu

if [[ $# -ne 4 ]]; then
    echo "Wrong arguments. Call this script with:"
    echo "${0} <containerName> <pathToAttachment> <Email> <Window>"
    exit 1;
fi


#date=`date +%d-%m-%Y`
date=`date +%d-%m-%Y:%H:%M:%S`
echo "Logging-date: ${date}"
outputFileName=${date}_logs

containerName=$1
attachment=${2}${outputFileName}
email=$3
window=$4
echo "Container to monitor: ${containerName} with window: ${window} seconds"

#sysdig -pc -M ${window} -w scap/${date}.scap -c spy_users container.name=${containerName} >> ${attachment}

nohup stdbuf -oL -eL sysdig -pc -G ${window} -W 2 -w test.scap -c spy_users container.name=${containerName} >> sample_logs 2>&1 &

echo "${date}_Logging-complete"
#echo "Removing scap to clear space"
#rm ${date}.scap

# Send Email
#echo "Sending mail"

#echo "Recipient: ${email} --------------- Attaching: ${attachment}"

#echo "Logs for ${date} ----- Please check " | mutt -a ${attachment} -s "Sysdig logging ${date}" -- ${email}

#echo "Mail sent"

exit 0
