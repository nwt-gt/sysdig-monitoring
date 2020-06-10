# sysdig-monitoring

Monitoring commands running in container using sysdig spy_users

# Setup

Create a workspace directory and in the directory, create a logs folder
```
mkdir logs 
```

Run Chmod +x to make the script executable
```
chmod +x sysdig-monitoring.sh 
chmod +x logs-filtering.sh 

```

# Monitoring of container

Run the sysdig-monitoring script with the following arguments.
 1. Name of container to monitor
 2. Monitoring window in seconds

Here I am using *docker_postgres.9.6_1* as the container with a monitoring window of *60 seconds*
```
./sysdig-monitoring.sh docker_postgres.9.6_1 60
```

# Filtering keywords from logs file
Run the logs-filtering scrip with the following arguments.
 1. Name of log file 
 2. Arbitrary number of arguments to filter
 
Here I am using *10-06-2020_logs* as the log file and filtering for sudo and su 
```
 ./logs-filtering.sh logs/10-06-2020_logs su sudo
 ```
 
# Check output

Tail the log files from above and run commands inside the container that is being monitored 

```
tail -f logs/10-06-2020_logs
tail -f logs/filtered_logs
docker exec -it docker_postgres.9.6_1 bash
```
