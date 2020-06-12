#!/bin/bash

# redirect notify stdout/stderr to a notify_logs
exec > >(tee -a logs/notify_logs) 2>&1

filePath=/home/nwt/swgapp/sysdig/logs/filter/*_logs

# moniters modification to the filePath and outputs path
inotifywait -m --event modify --format '%w' ${filePath} | while read f; do \
        #Able to do call. Eg Send email
        echo "$f"; \
        
    done

exit 0 
