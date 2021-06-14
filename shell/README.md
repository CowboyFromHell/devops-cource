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
6. Script shouldn't depend from access right privileges. It should give the user a warning message

Additional requirements:
1. Script outputs the number of connections for each organization
2. Script allows to get another information from whois
3. Script can work with 'ss', use utilities\built-ins, not only what's inside single-line command

---
## About shell script ProcessWhois.sh

Script that shows **IP Whois** information about connections by process name or PID

Requirements:
+ netstat (is part of the package ***net-tools***)
+ whois

Usage:
    
    processwhois.sh [-p] [-n 5] [-s ALL] [-w Organization] [-d] [-v] [-h]
or

    sudo processwhois.sh [-p] [-n 5] [-s ALL] [-w Organization] [-d] [-v] [-h]

Options:
+ -p Process name or PID (**required**)
+ -n Number of output lines, 5 by default (***optional***)
+ -s The state of socket (ALL by default, ESTABLISHED TIME_WAIT CLOSE_WAIT LISTEN as option) (***optional***)
+ -w Whois search phrase, "Organization" by default (For example: country, netname, create) (***optional***)
+ -d Debug mode, no argument needed (***optional***)
+ -v Version, no argument needed (***optional***)
+ -h Help information about script, no argument needed (***optional***)

Note: 
1. The order of the arguments is **not important**.
2. Any "extra" arguments or options **do not** affect the script.
3. If you run script without sudo - script will just inform you about that, but it will continue to work fine. However, not all processes in this case can be identified by the netstat utility.
4. For -h and -v options -p option isn't necessary.


Usage examples:

    sudo processwhois.sh -p 'Telegram' -n 4

![Example 1](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/shell/processwhois1.png?raw=true)

    processwhois.sh -p 'vivaldi' -n 1

![Example without sudo ](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/shell/processwhois_sudo_note.png?raw=true)

    sudo processwhois.sh -s 'CLOSE_WAIT' -n 7 -p 'vivaldi' 

![Example 2](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/shell/processwhois2.png?raw=true)

    sudo processwhois.sh -p 'chrome' -n 3 -d

![Example 3](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/shell/processwhois3.gif?raw=true)

    sudo processwhois.sh -p 3267 -n 4 -s ESTABLISHED

![Example 4](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/shell/processwhois4.png?raw=true)

    sudo processwhois.sh -h

![Example 5](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/shell/processwhois5.png?raw=true)

    sudo processwhois.sh -v

![Example 6](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/shell/processwhois6.png?raw=true)

    sudo processwhois.sh -p 'vivaldi' -w 'netname'

![Example 7](https://github.com/MikeKozhevnikov/devops-cource/blob/main/media/shell/processwhois7.png?raw=true)

## About how it works and what it contains

The original single-line script
    
    sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done

can be divided into **four** stages:

1. Executing the netstat utility with the "-tunapl" parameters
   
        netstat -tunapl 
2. Filtering results by process name (or PID) and IP address allocation

        awk '/firefox/ {print $5}' 
3. IP address processing, port trimming, sorting

        cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' 
4. Search Whois information on specific IP addresses

        while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done

In my realization of this shell script, I am doing all of these stages, step by step.

I also check for the necessary utilities in the system (whois & netstat), check the input data (required and optional), report errors (invalid parameter values), and implement additional functionality (-h -v -d -w options).