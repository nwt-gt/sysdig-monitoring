#!/bin/bash

set -eu
# redirect sysdig-monitoring stdout/stderr to a sysdig_logs
exec > >(tee -a logs/sysdig_logs) 2>&1

date=`date +%d-%m-%Y`
dateTime=`date +%d-%m-%Y:%H:%M:%S`

# Monitoring container
echo "***Sysdig Monitoring***"

# takes in 2 arg. containerName & monitoring window
if [[ $# -lt 2 ]]; then
    echo "Wrong arguments. Call this script with:"
    echo "${0} <containerName> <Window> <Optional-filterArg1> <Optional-filterArg2> ..."
    exit 1
elif [[ $# -gt 7 ]]; then 
    echo "Too many arguments. Call this script with:"
    echo "${0} <containerName> <Window> <Optional-filterArg1> <Optional-filterArg2> ..."
    exit 1
fi

echo "Logging-date --- ${dateTime}"

containerName=$1
window=$2

command="nohup stdbuf -oL -eL sysdig -pc -G ${window} -W 2 -w scap/test.scap -c spy_users \
container.name=${containerName}"

# runs command at background and stream scap output to logs directly
function monitor_func {

    echo "Container --- ${containerName}" && echo "Window --- ${window} seconds"
    outputFileName=logs/monitor/${date}_monitor_logs

    ${command} >> ${outputFileName} 2>&1 &
}

function filter_func {

    outputFileName=logs/filter/${date}_filter_logs
   
    echo "Container --- ${containerName}" && echo "Window --- ${window} seconds" && echo "Filter --- ${array}"
    echo "************"
    echo "${command} and proc.name=${filterArg}${tmp}"
    echo "************"
    ${command} and proc.name=${filterArg}${tmp} >> ${outputFileName} 2>&1 &
}


function add_filter {
    filterStr=" or proc.name=${filterArg}"
}


# Monitoring without filtering
if [[ $# -eq 2 ]]; then
    monitor_func

# Monitoring with filter
else

    tmp=''
    array="${@:3}"

# loop thru user input from 3rd argument on 
    for i in "${@:3}"; do
       
        filterArg=${i}

        # skip the last input arg to prevent duplicates. 
        # if filterArg1 is also the last arg. it will skip the remaining loop     
        if [[ $i == ${@: -1} ]]; then
            continue
        fi  
        # adds on to the sysdig list for more filters        
        add_filter
        tmp="${tmp}${filterStr}" 

    done 

    filter_func    
fi


exit 0
