#!/usr/bin/env bash

TMPRS="/tmp/raid_status.tmp"
TMPRI="/tmp/raid_info.tmp"
TMPHDD="/tmp/hdd_info.tmp"
TMPBT="/tmp/bt_info.tmp"
TMPVD="/tmp/vd_info.tmp"


################################################################################
# TMPBT
get_battery(){
    local tmp_file="${1}"
    /usr/sbin/megacli -AdpBbuCmd -aALL > ${tmp_file}
}

# TMPHDD
get_hdd(){
    local tmp_file="${1}"
    /usr/sbin/megacli -PDList -aALL > ${tmp_file}
}

# TMPRI
get_raid_info(){
    local tmp_file="${1}"
    /usr/sbin/megacli -AdpAllInfo -aAll > ${tmp_file}
}

# информация по состоянию контроллера TMPRS
get_controller_info(){
    local tmp_file="${1}"
    /usr/sbin/megacli -EncInfo -aALL > ${tmp_file}
}

# Adapter -- Virtual Drive Information TMPVD
get_vd_info(){
    local tmp_file="${1}"
    /usr/sbin/megacli -LDInfo -Lall -Aall  > ${tmp_file}
}
#################################################################################

get_battery_type(){
   local tmp_file="${1}"
   local BatteryType=$(cat ${tmp_file}|grep "BatteryType"|awk -F":" '{ print $2}')
   echo $BatteryType
}

get_hdd_info(){
    local tmp_file="${1}"
    tfile="/tmp/temp.tmp"
    # local text=$(cat ${tmp_file}|egrep "Enclosure Device ID:|Slot Number:|Inquiry Data:|Error Count:|state")
    local result="Slot Number \t Inquiry Data \t Firmware state \t Media Error Count \t Other Error Count \t Enclosure Device ID\n"
    cat ${tmp_file} | egrep "Enclosure Device ID:|Slot Number:|Inquiry Data:|Error Count:|state" | sed -e ':a;N;$!ba;s/\n/|/g' -e 's/|Enclosure/\nEnclosure/g' > ${tfile}
    while read line;do
    local slot=$( echo ${line}|awk -F"|" '{print $2}'|awk -F":" '{print $2}'|sed 's/ //')
    local ID=$( echo ${line}|awk -F"|" '{print $1}'|awk -F":" '{print $2}'|sed 's/ //')
    local data=$( echo ${line}|awk -F"|" '{print $6}'|awk -F":" '{print $2}'|sed 's/ //')
    local state=$( echo ${line}|awk -F"|" '{print $5}'|awk -F":" '{print $2}'|sed 's/ //')
    local mec=$( echo ${line}|awk -F"|" '{print $3}'|awk -F":" '{print $2}'|sed 's/ //')
    local oec=$( echo ${line}|awk -F"|" '{print $4}'|awk -F":" '{print $2}'|sed 's/ //')
    result+="\"${slot}\"\t\"${data}\"\t\"${state}\"\t\"${mec}\"\t\"${oec}\"\t\"${ID}\"\n"
    # result+="{\"{#PX_STORAGE_NAME}\":\"${name}\", \"{#PX_STORAGE_USAGE}\":\"${usage}\"},"
    done < ${tfile}
    echo -e ${result}
    #echo $text
}

get_raid_model() {
    local tmp_file="${1}"
    ProductName=$(cat ${tmp_file}|grep "Product Name"|awk -F":" '{ print $2}')
    echo $ProductName
}


get_raid_status(){
    # Optimal
    BatterySt=$(cat ${TMPBT}|grep "Battery State"|awk -F":" '{ print $2}')
    # Normal - raid status TMPRS
    ControllerSt=$(cat ${TMPRS}|grep "Status" | awk -F":" '{print $2}')
    # Online
    DiskSt=$(cat ${TMPHDD}|grep "Firmware state"|awk -F":" '{print $2}'|awk -F"," '{print $1}')
    # Bad Blocks Exist: No - вывод No TMPVD
    BadBl=$(cat ${TMPVD}|grep "Bad Blocks Exist" | awk -F":" '{print $2}')
    for item in ${DiskSt[*]}
    do
        if [[ $item = "Online" ]]
        then
         PhysDrStat="OK"
        else
         PhysDrStat="PROBLEM"
        break;
        fi
    done

    if [[ $BatterySt != "Optimal" && $ControllerSt != "Normal" && $PhysDrStat != "OK" && $BadBl != "No" ]]
    then
        echo 1
    else
        echo 0
    fi
}


###################################################################################

main() {
    ACTION=${1:-get_items}

    case "$ACTION" in
	"all_info_info")
	    echo "OK"
	    # cat "${TMP}"
	;;
	"get_raid_status")
	    get_battery "${TMPBT}"
	    get_hdd "${TMPHDD}"
	    get_controller_info "${TMPRS}"
	    get_vd_info "${TMPVD}"
	    get_raid_status
	;;
	"get_hdd_info")
	    get_hdd_info "${TMPHDD}"
	;;
	"get_battery_type")
	    get_battery_type "${TMPBT}"
	;;
	"get_raid_model")
	    get_raid_info "${TMPRI}"
	    get_raid_model "${TMPRI}"
	;;
	*)
	    zbxnotsupported
	;;
    esac
}

main "$@"

