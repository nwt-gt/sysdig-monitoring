#!/bin/bash

# redirect sysdig-monitoring stdout/stderr to a logFilters_logs
exec > >(tee -a logs/logFilters_logs) 2>&1

# Monitoring container
echo "***log filtering***"

set -eu

# takes in 3 arg. containerName & monitoring time
if [[ $# -lt 2 ]]; then
    echo "Wrong arguments. Call this script with:"
    echo "${0} <logfile> <filter-arg1> <filter-arg2> ..."
    exit 1;
fi

logfiles=$1

echo "filtering --- ${logfiles}" 

# sysout the logfile and what to filter for
# ignores first arg as it's the name of the log file
for var in "$@"
do
   if [[ ${var} == ${logfiles} ]];
   then 
      printf "arguments --- "
      continue
   fi 
   printf "${var} "
   
done
echo ""
# runs command at background and stream scap output to logs directly based on number of arg to filter
# ignores first arg as it's the name of the log file
for var in "$@"
do
   if [[ ${var} == ${logfiles} ]];
   then
      continue
   fi
   echo "${var}"
   tail -f ${logfiles} | grep -E --line-buffered "${var}" >> logs/filtered_logs &
done

exit 0
