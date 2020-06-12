#!/bin/bash

# redirect notify stdout/stderr to a notify_logs
exec > >(tee -a logs/notify_logs) 2>&1

set -eu

if [[ $# -ne 1 ]]; then
    echo "Please enter the file path"
    exit 1
fi

filePath=$1

# moniters modification to the filePath and outputs path
inotifywait -m --event modify --format '%w' ${filePath} | while read f; do
        # Able to trigger action. Eg Send email
        # Here I sysout the file details and append to trigger
        echo "Full path - ${f}"
        echo "File Name - ${f##*/}"; 
    done >> logs/trigger 2>&1 &

exit 0 
