Create cronjob and set to the desired frequency. Currently set to run every min.
```
* * * * * cd /home/nwt/swgapp/sysdig/ && ./sysdig-monitoring.sh docker_postgres.9.6_1 "${PWD}/logs/" weetong@dsaid.gov.sg >> /home/nwt/swgapp/sysdig/logs/sysdig_monitoring_logs 2>&1
```
