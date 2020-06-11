#!/bin/bash
# Run script monitoring && sendmail

# Exit code and default run code initialization
exit_A=0

#----------------------------------------------

date=`date +%d-%m-%Y`
containerName=$1
email=$2
attachmentPath=$3
attachment=${attachmentPath}${date}_logs

echo "Logging-date: ${date}"

# execute script A

. ./home/nwt/swgapp/sysdig/monitoring.sh ${containerName} ${date} ${exit_A}

echo "EXIT A $exit_A"

if [$exit_A==1] #only if A finishes without error 
then
#execute script B
. ./sendmail.sh ${attachment} ${email} 
else
echo "Error in monitoring script" >> /home/nwt/swgapp/sysdig/logs/script_log.txt
fi


now="$(date +'%d/%m/%Y-%T')"
#make a log in a file (print can be used for better formatting)
echo -e $now,$exit_A,$exit_B,$exit_C >>  /home/user/log/script_log.txt 
