#!/usr/bin/env bash

function process_logs() {

	declare -A -x -g log_data=()
	declare -A -x -g temp_table=()

	local logs="$( find $_ROOT/data/logs -type f -exec ls -al {} \; | awk '{print $9}' )"	
	local total_files=0
	local total_lines=0

	for record in $logs; do 

		local logfile=${record##*/} && str_split $logfile "_"
		local date=${str_split_result[1]}

		if [[ $date == '' ]]; then continue; fi
		while IFS= read -r line; do

			process_entry $date $line
			total_lines=$(($total_lines+1))

		done < "$record";
		total_files=$(($total_files+1))
	done
	
	printf "Processed \e[33m$total_files\e[0m files / \e[33m$total_lines\e[0m lines total \n"
	return 0
}

function process_entry() {

	local date=$1
	local size=$2
	local name=$3

	printf "\e[34m [processing] \e[0m \n" 
	printf "  date:\e[36m $date \e[0m \n"
	printf "  name:\e[32m $name \e[0m \n"
	printf "  size:\e[33m $size \e[0m \n"

	if [[ ${log_data[$2]+true} ]]; then
		
		# echo ${log_data[$2]}
		# echo $line
		echo " item already in table" : 
		
	else
		log_data[$2]=$1;
	fi
	
	return 0
}

# function filtered_sort() {


# }