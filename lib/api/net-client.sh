#!/usr/bin/env bash

function get_nasa_photo() {

	printf "\n\e[33m Retrieving image information... \e[0m \n\n"
	local url="https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
	local json=$( curl $url )
	local filename=""
	
	str_split "${json:1:-1}" ','
	declare -a fields=${str_split_result[@]}

	for field in ${fields[@]}; do

		if [[ ${field::6} == '"url":' ]]; then 

			local dl_url_part=${field##*'url":'}
			local dl_url=${dl_url_part:1:-1}
			
			filename=${dl_url##*/}
			download_photo $dl_url $filename
		fi
	done

	local timestamp=$(get_timestamp)
	local json_filename="${filename%".jpg"}.json"

	write_file "images/$json_filename" "$json"
	printf "\n Saved JSON to\e[33m $json_filename \e[0m \n\n"
}

function download_photo() {

	local dl_url=$1
	local path=$2

	printf "\n Downloading image from\e[36m $dl_url \e[0m \n"
	curl $dl_url > "data/images/$path"

	printf "\n Saved image to\e[33m $path \e[0m"
}