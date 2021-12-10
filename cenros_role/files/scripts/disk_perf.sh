#!/usr/bin/env bash

################################################################################

fstat="/sys/class/block/$2/stat"

################################################################################

get_dev_io_active(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $9}' ${filestat})
	echo "${result}"
}
get_read_ops(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $1}' ${filestat})
	echo "${result}"
}
get_read_merged(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $2}' ${filestat})
	echo "${result}"
}
get_read_sectors(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $3}' ${filestat})
	echo "${result}"
}
get_read_ms(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $4}' ${filestat})
	echo "${result}"
}
get_dev_write_ops(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $5}' ${filestat})
	echo "${result}"
}
get_dev_write_merged(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $6}' ${filestat})
	echo "${result}"
}
get_dev_write_sectors(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $7}' ${filestat})
	echo "${result}"
}
get_dev_write_ms(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $8}' ${filestat})
	echo "${result}"
}
get_dev_io_ms(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $10}' ${filestat})
	echo "${result}"
}
get_weight_io_ms(){
	local filestat="${1}"
	local result=$( /usr/bin/awk '{print $11}' ${filestat})
	echo "${result}"
}

###################################################################################

main() {
	ACTION=${1:-get_items}

	case "$ACTION" in
		"dev_io_active")
			get_dev_io_active "${fstat}"
		;;
		"dev_io_ms")
			get_dev_io_ms "${fstat}"
		;;
		"weight_io_ms")
			get_weight_io_ms "${fstat}"
		;;
		"read_ops")
			get_read_ops "${fstat}"
		;;
		"read_merged")
			get_read_merged "${fstat}"
		;;
		"read_sectors")
			get_read_sectors "${fstat}"
		;;
		"read_ms")
			get_read_ms "${fstat}"
		;;
		"dev_write_ops")
			get_dev_write_ops "${fstat}"
		;;
		"dev_write_merged")
			get_dev_write_merged "${fstat}"
		;;
		"dev_write_sectors")
			get_dev_write_sectors "${fstat}"
		;;
		"dev_write_ms")
			get_dev_write_ms "${fstat}"
		;;
		*)
			zbxnotsupported
		;;
	esac
}

main "$@"
