# sysdig-monitoring

Monitoring commands running in container using sysdig spy_users

# Limitations

Unable to send email directly to @hive-ida.slack.com domain as unable to configure to use dsaid.gov.sg directly from Ubuntu. Need access which is managed by domain [admin](https://myaccount.google.com/lesssecureapps)

# Setup

Create a workspace directory and in the directory, create a logs folder
```
mkdir logs 
```

Run Chmod +x to make the script executable
```
chmod +x sysdig-monitoring.sh 

```

# Testing

Run the script with the following arguments.
 1) Name of container to monitor
 2) Path of the attachment
 3) Email of Recipient
 4) Monitoring window in seconds

Here I am using *docker_postgres.9.6_1* as the container to monitor, *${PWD}/logs/* as attachment path and *weetong@dsaid.gov.sg* as the email address with a monitoring window of *60 seconds*
```
./sysdig-monitoring.sh docker_postgres.9.6_1 "${PWD}/logs/" weetong@dsaid.gov.sg 60
```


Example of success output.
```
Sysdig logging
Logging-date: 26-05-2020
Container to monitor: docker_postgres.9.6_1 with window: 60 seconds
26-05-2020_Logging-complete
Removing scap to clear space
Sending mail
Recipient: weetong@dsaid.gov.sg --------------- Attaching: /home/nwt/swgapp/sysdig/logs/26-05-2020_logs
Mail sent

```

Create cronjob and set to the desired frequency. Currently set to run every min.
```
* * * * * cd /home/nwt/swgapp/sysdig/ && ./sysdig-monitoring.sh docker_postgres.9.6_1 "${PWD}/logs/" weetong@dsaid.gov.sg >> /home/nwt/swgapp/sysdig/logs/sysdig_monitoring_logs 2>&1
```
