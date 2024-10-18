#!/usr/bin/env bash

################################################################################

AST=$(which asterisk)
TMP="/tmp/asterisk_queue_stats.tmp"
################################################################################

get_active_channel(){
	local result=$( ${AST} -rx "core show channels" | grep "active channel" | awk '{print $1}')
	echo "${result}"
}

get_active_calls(){
	local result=$( ${AST} -rx "core show channels" | grep "active call" | awk '{print $1}')
	echo "${result}"
}
get_softx3000(){
	local result=$( ${AST} -rx "core show channels" | grep -c "^SIP/softx3000")
	echo "${result}"
}
get_queue1000_calls(){
	local result=$( ${AST} -rx "queue show 1000" | grep 1000 | awk '{print $3}'} )
	echo "${result}"
}
get_queue1100_calls(){
	local result=$( ${AST} -rx "queue show 1100" | grep 1100 | awk '{print $3}'} )
	echo "${result}"
}
get_queue1191_calls(){
	local result=$( ${AST} -rx "queue show 1191" | grep 1191 | awk '{print $3}'} )
	echo "${result}"
}

###################################################################################

main() {
	ACTION=${1:-get_items}

	case "$ACTION" in
		"active_channel")
			get_active_channel
		;;
		"active_calls")
			get_active_calls
		;;
		"softx3000")
			get_softx3000
		;;
		"queue1000")
			get_queue1000_calls
		;;
		"queue1100")
			get_queue1100_calls
		;;
		"queue1191")
			get_queue1191_calls
		;;
		*)
			zbxnotsupported
		;;
	esac
}

main "$@"
