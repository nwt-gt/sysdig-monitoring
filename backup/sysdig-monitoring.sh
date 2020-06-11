#!/bin/bash

# redirect sysdig-monitoring stdout/stderr to a sysdig_logs
exec > >(tee -a logs/sysdig_logs) 2>&1

# Monitoring container
echo "***Sysdig logging***"

set -eu

# takes in 2 arg. containerName & monitoring window
if [[ $# -ne 2 ]]; then
    echo "Wrong arguments. Call this script with:"
    echo "${0} <containerName> <Window>"
    exit 1;
fi


date=`date +%d-%m-%Y`
dateTime=`date +%d-%m-%Y:%H:%M:%S`

echo "Logging-date --- ${dateTime}"

outputFileName=${date}_logs
containerName=$1
window=$2

echo "Container to monitor --- ${containerName}" && echo "Window --- ${window} seconds"

# runs command at background and stream scap output to logs directly
nohup stdbuf -oL -eL sysdig -pc -G ${window} -W 2 -w scap/test.scap -c spy_users container.name=${containerName} >> logs/${outputFileName} 2>&1 &

exit 0
