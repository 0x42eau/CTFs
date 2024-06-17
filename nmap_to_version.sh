#!/bin/bash

# ./nmap_to_version.sh <ip>

if [ $# -ne 1 ]; then
	echo 'Usage: ./nmap_to_version.sh <ip>'
	echo 'Example: ./nmap_to_version.sh 10.10.11.12'
	exit -1
fi

ip=$1

nmap -p- -vv -Pn -n $ip -oA all-ports

cat all-ports.xml | grep -i portid | awk '{print $3}' | awk -F '"' '{print $2}' > ports.txt

nmap -p$(cat ports.txt) -sV -sC -Pn -n -vv $ip -oA service-scan
