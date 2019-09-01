#!/usr/bin/env bash

function write_file() {

	local path=$_ROOT"/data/"$1
	printf "$2" > $path
	echo "file saved at $path"
}

function write_log() { write_file 'logs/'$1 "$2"; }

function scan_large_files() {

	local msg="usage: ./bash-example.sh scan-large-files num_files"
	if [[ $# < 1 ]]; then exit_with_help "$msg"; fi

	local data="$( find . -type f -exec ls -al {} \; | awk '{print $5,  $9}' | sort -nr -k1 | head -n $1 )"
	local timestamp=$(get_timestamp)

	write_log "scan__$timestamp.log" "$data"
	return 0;
}
