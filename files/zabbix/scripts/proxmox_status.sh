#!/usr/bin/env bash

################################################################################
#
# Author:   Alexey Egorychev <me@jnotes.ru>
# Version:  0.2
# License:  GPLv3
#
################################################################################

TMP="/tmp/pvesm_status.tmp"
TMP1="/tmp/pvecm_status.tmp"

################################################################################

get_pvesm_status(){
	local tmp_file="${1}"
	cp -f ${tmp_file} ${tmp_file}"_2"
	sudo pvesm status | grep -v "disabled\|Name" > ${tmp_file}
	
}

get_pvecm_status(){
	local tmp_file="${1}"
	cp -f ${tmp_file} ${tmp_file}"_2"
	sudo pvecm status > ${tmp_file}
}

zbxnotsupported() {
	echo "ZBX_NOT_SUPPORTED"
	exit 1
}

storages_discovery(){
	local tmp_file="${1}"
	echo -e "{\n\t\"data\":["
	while read line;do
		local name=$(echo ${line}|awk '{print $1}')
		local usage=$(echo ${line}|awk '{print $7}')
		result+="{\"{#PX_STORAGE_NAME}\":\"${name}\", \"{#PX_STORAGE_USAGE}\":\"${usage}\"},"
	done < ${tmp_file}
	echo -e "\t\t${result}"|sed 's/.$//'
	echo -e "\t]\n}"
}

get_pvecm_quorate(){
	local tmp_file="${1}"
	local result=$(cat ${tmp_file}|grep -oP "Quorate:\s+\K\w+"|grep -c "Yes" )
	echo ${result}
}
get_pvecm_nodes(){
	local tmp_file="${1}"
	local result=$(cat ${tmp_file}|grep -i "^Nodes:"|awk '{print $2}' )
	echo ${result}
}

###################################################################################

main() {
	ACTION=${1:-get_items}

	case "$ACTION" in
		"all_cluster_info")
			get_pvecm_status "${TMP1}"
			get_pvesm_status "${TMP}"
			echo "OK"
			# cat "${TMP}"
		;;
		"storages_discovery")
			storages_discovery "${TMP}""_2"
		;;
		"get_pvesm_status")
#			get_pvesm_status "${TMP}"
			cat "${TMP}""_2"
		;;
		"get_pvecm_status")
#			get_pvecm_status
			cat "${TMP1}""_2"
		;;
		"get_pvecm_quorate")
			get_pvecm_quorate "${TMP1}""_2"
		;;
		"get_pvecm_nodes")
			get_pvecm_nodes "${TMP1}""_2"
		;;
		*)
			zbxnotsupported
		;;
	esac
}

main "$@"
