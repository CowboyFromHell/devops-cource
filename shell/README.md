# Shell script hometask

### Task:

Create shell script from this single-line command:

    sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done

Requirements:
1. Create README.md file and write what your script must do
2. Script must accept process name or PID as an argument
3. Output lines also must be specified by the user
4. Should be possible to see other connection states
5. Script should give the user simple and understangable error messages
6. Script shouldn't depend from access right privileges. It should give the user a warning message.

Additional requirements:
1. Script outputs the number of connections for each organization
2. Script allows to get another information from whois
3. Script can work with 'ss'

---
## About shell script ProcessWhois.sh

Script that shows **IP Whois** information about connections by process name or PID

Requirements:
+ netstat (is part of the package ***net-tools***)
+ whois

Usage:
    
    processwhoise.sh [-p] [-n 5] [-s] [-d] [-v] [-h]
or

    sudo processwhoise.sh [-p] [-n 5] [-s] [-d] [-v] [-h]

Options:
+ -p Process name or PID (**required**)
+ -n Number of output lines, 5 by default (***optional***)
+ -s The state of socket (ALL by default, ESTABLISHED TIME_WAIT CLOSE_WAIT LISTEN as option) (***optional***)
+ -d Debug mode, no argument needed (***optional***)
+ -v Version, no argument needed (***optional***)
+ -h Help information about script, no argument needed (***optional***)

Note: 
1. The order of the arguments is **not important**
2. Any "extra" arguments or options **do not** affect the script


Usage examples:

    processwhoise.sh -p 'vivaldi' -n 15

screenshot

    processwhoise.sh -s 'LISTEN' -n 7 -p 'telegram' 

screenshot

    processwhoise.sh -p 'chrome' -d

screenshot

    processwhoise.sh -p 5267 -n 3 -s CLOSE_WAIT

screenshot