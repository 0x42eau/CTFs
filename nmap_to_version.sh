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

nmap -p$(paste -sd, - < ports.txt) -sV -sC -Pn -n -vv $ip -oA service-scan

echo ''
echo ''
echo '############################'
echo 'running udp scan - can take some time'
echo '############################'
echo ''
echo ''
sleep 3s


nmap -sU --top-ports 100 -Pn -n -vv $ip -oA udp-top100
cat udp-top100.xml | grep -i portid | awk '{print $3}' | awk -F '"' '{print $2}' > udpports.txt
nmap -p$(paste -sd, - < udpports.txt) -sU -sV -sC -Pn -n -vv $ip -oA udpservice-scan

