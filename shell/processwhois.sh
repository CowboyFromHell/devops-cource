#!/bin/bash
# Script that shows IP Whois information about connections by process name or PID

version=0.3

# Help information for -h option
help_info=$(cat <<EOF
Script that shows IP Whois information about connections by process name or PID

Usage:
    processwhois.sh [-p] [-n 5] [-s ALL] [-w Organization] [-d] [-v] [-h]
or
    sudo processwhois.sh [-p] [-n 5] [-s ALL] [-w Organization] [-d] [-v] [-h]

Options:
-p Process name or PID (required)
-n Number of output lines, 5 by default (optional)
-s The state of socket (ALL by default, ESTABLISHED TIME_WAIT CLOSE_WAIT LISTEN as option) (optional)
-w Whois search phrase, "Organization" by default (optional)
-d Debug mode, no argument needed (optional)
-v Version, no argument needed (optional)
-h Help information about script, no argument needed (optional)

Examples:
    processwhois.sh -p 'vivaldi' -n 15
    processwhois.sh -s 'LISTEN' -n 7 -p 'telegram' 
    processwhois.sh -p 'chrome' -d
    processwhois.sh -p 5267 -n 3 -s CLOSE_WAIT
    processwhois.sh -p 'vivaldi' -w 'netname'
EOF
)

# Preparing checks: access rights, netstat & whois availability on system, 
# Check the script is being run by root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root to see all available information"
fi

if [[ -z "$(which netstat)" ]]; then
    echo "You have not netstat on your system! You may install it with net-tools package and try again"
    exit
fi

if [[ -z "$(which whois)" ]]; then
    echo "You have not whois on your system! You may install it and try again."
    exit
fi

# Default values for arguments and variables
num_default=5
state_default='ALL'
socket_states=(ESTABLISHED TIME_WAIT CLOSE_WAIT LISTEN)
debug_flag=0
version_flag=0
help_flag=0
debug_info=''
whois_default='Organization'

# Collecting agruments
debug_info+="Arguments parsing STARTS:\n\n"
while [ -n "$1" ]; do
    case "$1" in
    -p) param="$2" 
        process=$param
        debug_info+="Found the -p (process name or PID) option with argument value $param\n"
        shift ;;
    -n) param="$2"
        num=$param
        debug_info+="Found the -n (number of lines) option with argument value $param\n"
        shift ;;
    -s) param="$2"
        state=$param
        debug_info+="Found the -s (socket state) option with argument value $param\n"
        shift ;;
    -w) param="$2"
        whois_search=$param
        debug_info+="Found the -w (whois search phrase) option with argument value $param\n"
        shift ;;    
    -d) debug_flag=1
        debug_info+="Found the -d (debug) option\n";;
    -v) version_flag=1
        debug_info+="Found the -v (version) option\n";;
    -h) help_flag=1
        debug_info+="Found the -h (help) option\n";;   
    --) shift
        break ;;
    *) debug_info+="$1 is not an option for that script, it has no effect\n";;
    esac
    shift
done
debug_info+="\nArguments parsing ENDS.\n\n"

if [[ "$help_flag" == 1 ]]; then
    echo "${help_info}"
    exit
fi

if [[ "$version_flag" == 1 ]]; then
    echo "$(basename $0) version: $version"
    exit
fi

debug_info+="Collected arguments and variables:\n\nscriptname:\t $(basename $0)\nprocess:\t $process\nnum:\t\t $num\nstate:\t\t $state\nwhois_search:\t $whois_search\ndebug_flag:\t $debug_flag\nversion_flag:\t $version_flag\nhelp_flag:\t $help_flag\n\nSTART CHEСKING:\n"

if [[ "$debug_flag" == 1 ]]; then
    echo -e $debug_info
    debug_info=''
fi

# Checking agruments values for correctness and changing them to defaults if necessary
if [ -z "$process" ]; then
    echo "Process name\PID argument (-p) isn't set. Try again with -p 'process name\PID' option"\n 
    exit
fi

if [ -z "$num" ]; then
    num=$num_default
fi

if [[ "$num" =~ [^0-9]+ ]]; then
  echo "Lines number (-n) argument is incorrect. Using dafault value = $num_default"
  num=$num_default
fi

if [ -z "$state" ]; then
  state=$state_default
elif [[ " ${socket_states[*]} " != *" $state "* ]]; then
    echo "State (-s) argument is set, but incorrect. Using dafault value = $state_default"
    state=$state_default
fi

if [ -z "$whois_search" ]; then
  whois_search=$whois_default
fi

debug_info+="\nEND CHECKING\n\nCollected arguments and variables after checking:\n\nscriptname:\t $(basename $0)\nprocess:\t $process\nnum:\t\t $num\nstate:\t\t $state\nwhois_search:\t $whois_search\ndebug_flag:\t $debug_flag\nversion_flag:\t $version_flag\nhelp_flag:\t $help_flag\n\n"


if [[ "$debug_flag" == 1 ]]; then
    echo -e $debug_info
    debug_info=''
fi

# Get netstat dump with specific or default state
if [[ "$state" != "ALL" ]]; then  
    ip="$(netstat -tunapl | grep "$state")"
else
    ip="$(netstat -tunapl)"
fi

ip=$(echo "$ip" | awk '/'"$process"/' {print $5}')

if [[ ! -z "$ip" ]]; then
    ip=$(echo "$ip" | cut -d: -f1 | sort | uniq -c | sort | tail -n"$num" | grep -oP '(\d+\.){3}\d+')
else
    echo "No results for process $process"
    exit
fi

# Found ip (for debug)
debug_info+="IP:\n"
for i in ${ip}; do
    debug_info+="$i\n"
done

if [[ "$debug_flag" == 1 ]]; then
    echo -e $debug_info
    debug_info=''
fi

# Final output
for i in ${ip}; do
    result="$(whois "$i" | awk -F':' '/^'$whois_search'/ {print $2}')"
    if [[ -z "$result" ]]; then
        echo "$whois_search is not specified"
    else 
        echo $result
    fi
done