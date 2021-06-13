#!/bin/bash
# Script that shows IP Whois information about connections by process name or PID

# Preparing checks: netstat & whois availability, access rights 
# Check the script is being run by root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root to see all available information"
fi

# Default values for arguments
num_default=5
state_default='ALL'
socket_states=(ESTABLISHED TIME_WAIT CLOSE_WAIT LISTEN)

# Collecting agruments
while [ -n "$1" ]; do
    case "$1" in
    -p) param="$2" 
        process=$param
        echo "Found the -p option with parameter value $param"
        shift ;;
    -n) param="$2"
        num=$param
        echo "Found the -n option, with parameter value $param"
        shift ;;
    -s) param="$2"
        state=$param
        echo "Found the -s option with parameter value $param"
        shift ;;
    --) shift
        break ;;
    *) echo "$1 is not an option for that script, it has no effect";;
    esac
    shift
done

echo 'Collected arguments:'
echo 'scriptname: '$0
echo 'process:' $process
echo 'num: '$num
echo 'state: ' $state
echo

echo 'START CHEСKING:'

# Checking agruments values for correctness and changing them to defaults if necessary
if [ -z "$process" ]; then
  echo "Process name\PID argument (-p) isn't set. Try again with -p 'process name\PID' option"
  exit
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

echo 'END CHEKING'
echo
echo 'After checking:'
echo 'scriptname: '$0
echo 'process:' $process
echo 'num: '$num
echo 'state: ' $state

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

echo 

# Found ip
echo 'IP:'
for i in ${ip}; do
    echo $i
done

echo

# Final output
echo 'Organizations:'
for i in ${ip}; do
    result="$(whois "$i" | awk -F':' '/^Organization/ {print $2}')"
    if [[ -z "$result" ]]; then
        echo 'Organization is not specified'
    else 
        echo $result
    fi
done