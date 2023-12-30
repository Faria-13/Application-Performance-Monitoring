#!/bin/bash

duration=900


#starts all processes, grabs process IDs, stores them
startAPM(){
	./project1_executables/APM1 127.0.0.1 &
	pid1=$!
	./project1_executables/APM2 127.0.0.1 &
	pid2=$!
	./project1_executables/APM3 127.0.0.1 &
	pid3=$!
	./project1_executables/APM4 127.0.0.1 &
	pid4=$!
	./project1_executables/APM5 127.0.0.1 &
	pid5=$!
	./project1_executables/APM6 127.0.0.1 &
	pid6=$!
	ifstat -a -d 1 2> /dev/null
	#echo $(jobs)
	echo ---------jobs started----------
}


#ends all processes one by one
cleanup(){
	echo "----------ending jobs----------"
	kill %1
	kill %2
	kill %3
	kill %4
 	kill %5
	kill %6
	#echo $(jobs)
}

#this function collects process level data, which is memory usage and CPU usage
 
collect_PLD(){
	out=$(ps -aux | grep $pid1 | head -1 | awk -F " " '{print $3 ", " $4}')
	echo $sec", "$out >> "APM1.csv"
	out=$(ps -aux | grep $pid2 | head -1 | awk -F " " '{print $3 ", " $4}')
        echo $sec", "$out >> "APM2.csv"
	out=$(ps -aux | grep $pid3 | head -1 | awk -F " " '{print $3 ", " $4}')
        echo $sec", "$out >> "APM3.csv"
	out=$(ps -aux | grep $pid4 | head -1 | awk -F " " '{print $3 ", " $4}')
        echo $sec", "$out >> "APM4.csv"
	out=$(ps -aux | grep $pid5 | head -1 | awk -F " " '{print $3 ", " $4}')
        echo $sec", "$out >> "APM5.csv"
	out=$(ps -aux | grep $pid6 | head -1 | awk -F " " '{print $3 ", " $4}')
        echo $sec", "$out >> "APM6.csv"


}


#This function collects system level metrics and outputs to a file when it is run. 
collect_SLD(){
	RXrate=$( ifstat | grep ens33 | awk -F " " '{print $7 ", " $9}' )
	WriteRate=$( iostat | grep sda | awk -F " " '{print $4}')
	DiskCapacity=$( df | grep "/dev/mapper/centos-root" | cut -d " " -f 4 )
	echo $sec", "$RXrate", "$WriteRate", "$DiskCapacity >> "system_metrics.csv"
}


#This function calls the PLD and SLD function every 5 seconds until it reaches the duration

bigmainguy(){
	startAPM
	while [[ $SECONDS -lt $duration ]]; do
		time=$(( $SECONDS % 5 ))
		if [[ $time -eq 0 ]]; then
			sec=$SECONDS
			collect_SLD
			collect_PLD
		fi
	sleep 1
	done
	cleanup
}

bigmainguy
