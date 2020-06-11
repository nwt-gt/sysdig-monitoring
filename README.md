# sysdig-monitoring

Monitoring commands running in container using sysdig spy_users

# Setup

Create a workspace directory and in the directory, create a logs folder
```
mkdir -p logs/monitor
mkdir -p logs/filter
```

Run Chmod +x to make the script executable
```
chmod +x sysdig-filtering.sh 

```

# Monitoring of container

Run the sysdig-filtering script with the following arguments.
 1. Name of container to monitor
 2. Monitoring window in seconds

Here I am using *docker_postgres.9.6_1* as the container with a monitoring window of *60 seconds*
```
./sysdig-filtering.sh docker_postgres.9.6_1 60
```

# Monitoring and filtering of commands executed in container
Run the sysdig-filtering scrip with the following arguments.
 1. Name of container to monitor
 2. Monitoring window in seconds
 3. Keywords to filter. *Maximum of 5 - can be changed from source code* 
 
Here I added keywords filtering of sudo and su 
```
./sysdig-filtering.sh docker_postgres.9.6_1 60 sudo su
 ```
 
# Check output

Tail the log files from above and run commands inside the container that is being monitored 

```
tail -f logs/monitor/11-06-2020_monitor_logs
tail -f logs/filter/11-06-2020_filter_logs
docker exec -it docker_postgres.9.6_1 bash
```
