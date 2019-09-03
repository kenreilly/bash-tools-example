#!/usr/bin/env bash
source ./lib/config.sh
source ./lib/utility.sh
source ./lib/api/file-io.sh
source ./lib/api/net-client.sh
source ./lib/api/log-processor.sh

function main() {

	init_dir './data'
	init_dir './data/logs'
	init_dir './data/reports'
	init_dir './data/archives'
	init_dir './data/images'

	declare -A -x command_table=(
		['scan-files']="scan_large_files" 
		['process-logs']="process_logs"
		['get-photo']="get_nasa_photo"
	)

	local commands="${!command_table[@]}"
	local msg="usage: ./bash-example.sh [ $commands ]"
	if [[ $# < 1 ]]; then exit_with_help "$msg"; fi

	local command=${1}; shift
	local fn_name=${command_table[$command]}

	if [[ $fn_name == '' ]]; then exit_with_help "$msg"; fi
	if $fn_name $@; then return 0; else return 1; fi
}