# thread-dump-BASH-teedeedubya
## Description
- A simple BASH script that takes periodic dumps of a java thread.  How often it runs is based on what is configured inside of the crontab.  
- Run this as the user who owns the Java process
- This cleans up after itself and will delete older thread dumps dirs based on how many days of retention is configured

## Variables
- LOG_DIRECTORY : default '/var/log/thread_dumps', this defines where the dumps will be stored
- RETENTION_DAYS : default '7', this defines how many days thread dumps should be kept before being deleted
- DUMP_MODE : default '744', this defines the linux file permissions that should be placed on a thread dump
- PROCESS : default 'tomcat-juli', this defines what the process name is, this string is used to grep for the process via the ps command

## Usage
### Running the command from CLI:
sudo -u tomcat /opt/scripts/thread_dump.sh

### Sample Crontab configuration in /etc/crontab
0 * * * * tomcat /opt/scripts/thread_dump.sh

## Notes
-  This thing doesn't accept any arguments so you'll need to modify the scripts/thread_dump
-  You'll also need to create the log directory defined in the LOG_DIRECTORY variable