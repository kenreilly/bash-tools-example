#!/usr/bin/env bash

function exit_with_help() { echo $1 && exit_script; }

function get_timestamp() { printf $(date '+%Y-%m-%d__%H:%M:%S');  }

function init_dir() { [[ -d $_ROOT'/'$1 ]] || mkdir $_ROOT'/'$1; }