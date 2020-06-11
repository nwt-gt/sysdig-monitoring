#!/bin/bash

# Monitoring container
echo "***Sysdig logging***"

set -eu

if [[ $# -ne 2 ]]; then
    echo "Wrong arguments. Call this script with:"
    echo "${0} <containerName> <Window>"
    exit 1;
fi


date=`date +%d-%m-%Y`

dateTime=`date +%d-%m-%Y:%H:%M:%S`
echo "Logging-date --- ${dateTime}"
outputFileName=${date}_logs

#attachment=${2}${outputFileName}
#email=$3
containerName=$1
window=$2

echo "Container to monitor --- ${containerName}"
echo "window --- ${window} seconds"

#sysdig -pc -M ${window} -w scap/${date}.scap -c spy_users container.name=${containerName} >> ${attachment}

nohup stdbuf -oL -eL sysdig -pc -G ${window} -W 2 -w scap/test.scap -c spy_users container.name=${containerName} >> logs/${outputFileName} 2>&1 &


#echo "Removing scap to clear space"
#rm ${date}.scap

# Send Email
#echo "Sending mail"
#echo "Recipient: ${email} --------------- Attaching: ${attachment}"
#echo "Logs for ${date} ----- Please check " | mutt -a ${attachment} -s "Sysdig logging ${date}" -- ${email}
#echo "Mail sent"

exit 0
