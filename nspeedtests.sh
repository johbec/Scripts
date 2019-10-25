#!/bin/bash
####################################################
# Requires python-pip and pip package speedtest-cli
# > apt update
# > apt install python-pip
# > pip install speedtest-cli
####################################################
#Author: Johan Becker
#Copyright: Johan Becker 2019
####################################################

#Check if verbose is specified or not. Also check if user supplied anything else and inform them about usage.
if [[ $1 =~ "-v" ]]; then
	verbose=1 
elif [[ ! -z "$1" ]]; then
  echo "Usage: ./nspeedtest.sh [-v for verbose output]"
  exit 1
else
	verbose=0 
fi
#echo $verbose


unset numTimes
while [[ ! ${numTimes} =~ ^[0-9]+$ ]]; do
	echo "Please enter number of speedtests to run:"
	read numTimes
done
if [[ $verbose = "1" ]]; then
	echo "    INFO: Ok, ${numTimes} speedtests will be performed, which take 24 seconds each."
fi
numSeconds=$((24*$numTimes))
numSecsLeft=$numSeconds
numMinutes=$(($numSeconds/60)) 
echo "    INFO: Total time for all tests will be $(($numSeconds/60)) minutes and $(($numSeconds % 60)) seconds" # to complete"
pingTot=0.00 #$((0.00))
dlTot=0.00 #$((0.00))
ulTot=0.00 #$((0.00))
pingDlUl=""
for ((i=1; i<= $numTimes; i++)); 
do
	#echo "Speedtest ${i}"
	resString=$(speedtest-cli --simple);
	echo $resString
	pingDlUl=$(echo $resString | grep -P -o "(\d+\.\d+)")
	#echo $pingDlUl
	#pingDlUlarray=pdua
	pdua=($pingDlUl)
	#echo ping is ${pdua[0]}
	#echo DL speed was ${pdua[1]}
	#echo UL speed was ${pdua[2]} 
	#pingTot=$((${pingTot}+${${pdua[0]}}))
	pingTot=$(echo "scale=2; $pingTot + ${pdua[0]}" | bc)
	dlTot=$(echo "scale=2; $dlTot + ${pdua[1]}" | bc) #$((${dlTot}+${pdua[1]}))
	ulTot=$(echo "scale=2; $ulTot + ${pdua[2]}" | bc) #$((${ulTot}+${pdua[2]}))
	#echo pingDlUl is $pingdlUl
	numSecsLeft=$(($numSecsLeft-24))
	if [[ $(($i % 3)) = 0 ]]; then 
		if [[ $verbose = "1" ]]; then
			echo "    INFO: $numSecsLeft seconds left of the test"
		fi
	fi  
done
#avgPing=$(($pingTot / $numTimes))
#avgDl=$(($dlTot / $numTimes))
#avgUl=$(($ulTot / $numTimes))
avgPing=$(echo "scale=2; $pingTot / $numTimes" | bc) #($pingTot / $numTimes))
avgDl=$(echo "scale=2; $dlTot / $numTimes" | bc) #($dlTot / $numTimes))
avgUl=$(echo "scale=2; $ulTot / $numTimes" | bc) #($ulTot / $numTimes))

echo "STATS: Average ping was $avgPing ms, average DL speed was $avgDl Mbit/s, average UL speed was $avgUl Mbit/s"
#read -p  "How many speedtests?" num
#
#if [[ -z "$num"]]; then 
#	printf '%s\n' "No input entered"
#	exit 1
#else
	

#do
#record=${NUM}
#done
#echo ${record}
#echo ${NUM}

