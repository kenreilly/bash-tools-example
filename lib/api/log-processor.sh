#!/usr/bin/env bash

function process_logs() {

	declare -A -x -g log_data=()

	local logs="$( find $_ROOT/data/logs/*.log -type f -exec ls -al {} \; 2>/dev/null | sort -nr -k1 | awk '{print $9}'  )"	
	local total_files=0
	local total_lines=0

	if [[ ${#logs} == 0 ]]; then 
		printf "\n No log files to process, exiting. \n\n"
		exit
	fi

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
	
	printf "\n Processed \e[33m$total_files\e[0m files / \e[33m$total_lines\e[0m lines total \n\n"

	local timestamp=$(get_timestamp)
	local path="reports/report_$timestamp.yaml"

	create_report $path
	printf " Created report \e[33m./$path\e[0m"

	create_archive
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

	if [[ ${log_data[name]+true} ]]; then
		
		local item=${log_data[name]}
		local item_date=${item#*" "}

		if [[ $item_date > $date ]]; then
			add_item $name $size $date
		fi
	else
		add_item $name $size $date
	fi

	return 0
}

function add_item() { log_data[$1]="$2 $3"; }

function create_report() {

	local path=$1
	local yaml_out="files:\n"

	for name in ${!log_data[@]}; do

		local item=${log_data[$name]}
		local item_date=${item#*" "}
		local item_size=${item%$item_date}

		yaml_out=${yaml_out}"  -\n"
		yaml_out=${yaml_out}"    name: $name \n"
		yaml_out=${yaml_out}"    date: $item_date \n"
		yaml_out=${yaml_out}"    size: $item_size \n"
	done

	write_file $path "$yaml_out"
}