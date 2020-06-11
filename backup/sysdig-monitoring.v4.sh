#!/bin/bash

# redirect sysdig-monitoring stdout/stderr to a sysdig_logs
exec > >(tee -a logs/sysdig_logs) 2>&1

# Monitoring container
echo "***Sysdig logging***"
set -eu

# takes in 2 arg. containerName & monitoring window
if [[ $# -lt 2 ]]; then
    echo "Wrong arguments. Call this script with:"
    echo "${0} <containerName> <Window> <Optional-filterArg1> <Optional-filterArg2> ..."
    exit 1
fi

date=`date +%d-%m-%Y`
dateTime=`date +%d-%m-%Y:%H:%M:%S`

echo "Logging-date --- ${dateTime}"

containerName=$1
window=$2

command="nohup stdbuf -oL -eL sysdig -pc -G ${window} -W 2 -w scap/test.scap -c spy_users \
container.name=${containerName}"

# runs command at background and stream scap output to logs directly
function monitor_func {

    echo "Container --- ${containerName}" && echo "Window --- ${window} seconds"

    ${command} >> ${outputFileName} 2>&1 &
}

function filter_many_func {

    outputFileName=${date}_filter_logs
   
    echo "Container --- ${containerName}" && echo "Window --- ${window} seconds" && echo "Filter --- ${array}"
    echo "************"
    #echo "${command} and proc.name=${filterArg}${tmp}"
    echo "proc.name=${filterArg}${tmp}"
    echo "************"
    #${command} and proc.name=${filterArg}${tmp} >> logs/filter/${outputFileName} 2>&1 &
}


function add_filter {
    filterStr=" or proc.name=${filterArg}"
}


if [[ $# -eq 2 ]]; then
    monitor_func

elif [[ $# -gt 2 ]] || [[ $# -lt 7 ]]; then

    tmp=''
    check=false
    array="${@:3}"
    for i in "${@:3}"; do
       
        filterArg=${i}
        if [[ $# -eq 3 ]]; then
            filter_many_func
            break
        fi
        if [[ $i == ${@: -1} ]]; then
            echo "MATCHED !!!!!"
            continue
        fi    
        add_filter
        tmp="${tmp}${filterStr}" 

    done    
    filter_many_func    
       
else
    echo "Too many arguments"
fi


exit 0
