#!/bin/bash

echo "Sending mail"

date=`date +%d-%m-%Y`
emailPath=$1
attachment=${emailPath}${date}_logs
email=$2

echo "Recipient: ${email} --------------- Attaching: ${attachment}"

echo "Logs for $date ----- Please check " | mutt -a ${attachment} -s "Sysdig logging ${date}" -- ${email}

echo "Mail sent"
