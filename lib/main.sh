#!/usr/bin/env bash

source ./lib/config.sh
source ./lib/utility.sh
source ./lib/api/file-io.sh

function main() {

	init_dir './data'

	declare -A -x command_table=(
		['scan-files']="scan_large_files" 
		['process-logs']="process_log_data"
	)

	local commands="${!command_table[@]}"
	local msg="usage: ./bash-example.sh [ $commands ]"
	if [[ $# < 1 ]]; then exit_with_help "$msg"; fi

	local command=${1}; shift
	local fn_name=${command_table[$command]}

	if [[ $fn_name == '' ]]; then exit_with_help "$msg"; fi
	if $fn_name $@; then return 0; else return 1; fi
}