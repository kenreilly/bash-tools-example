#!/usr/bin/env bash

function write_file() { printf "$2" > $_ROOT"/data/"$1; }

function write_log() { write_file 'logs/'$1 "$2"; }

function scan_large_files() {

	local msg="usage: ./bash-example.sh scan-files num_files"
	if [[ $# < 1 ]]; then exit_with_help "$msg"; fi

	local data="$( find . -type f -exec ls -al {} \; | awk '{print $5,  $9}' | sort -nr -k1 | head -n $1 )"
	local timestamp=$(get_timestamp)

	write_log "scan_$timestamp.log" "$data"
	printf "\n Created logfile\e[33m data/logs/scan_$timestamp.log \e[0m \n\n"
	return 0;
}

function create_archive() {

	local timestamp=$(get_timestamp)
	local filename="data/archives/archive_${timestamp}.tar.gz"

	tar -czf $filename data/logs/*.log
	rm -rf $_ROOT/data/logs/*.log
	
	printf "\n Created archive\e[33m ./$filename \e[0m \n\n"
	return 0;
}