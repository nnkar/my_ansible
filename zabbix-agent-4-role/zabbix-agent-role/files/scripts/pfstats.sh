#!/usr/bin/env bash

TMPDAT="/tmp/pfstats.dat"
LOCK="/tmp/pfstats.lock"
CACHE=60

###############################################################################

NORM=0
BOLD=1
UNLN=4
RED=31
GREEN=32
BROWN=33
BLUE=34
MAG=35
CYAN=36
GREY=37

###############################################################################

show() {
    if [[ -n "$2" ]] ; then
        echo -e "\e[${2}m${1}\e[0m"
    else
        echo -e "$1"
    fi
}

usage(){
    echo "Usage: $0 <received|delivered|forwarded|deferred|bounced|rejected|held|discarded|reject_warnings|bytes_received|bytes_delivered>"
}

getstatfromlog() {
    #show "Getting number of lines ..."
    CURRENTPOS=`awk 'END {print NR}' /var/log/maillog`
    if [ -f ${TMPDAT} ];then
        FROMPOS=`tail -n 1 ${TMPDAT}`
    else
        FROMPOS=""
    fi
    #show "Checking last position ..."
    if [ "${FROMPOS}" != "" ];then
        if [ ${FROMPOS} -lt ${CURRENTPOS} ];then
            #show "Getting data from log to result file ..."
            tail -n +${FROMPOS} /var/log/maillog | pflogsumm --detail 0 | sed 's/^[ \t]*//g;s/bytes received/bytes_received/;s/bytes delivered/bytes_delivered/g' | grep "^[0-9km]\+" | grep "received\|delivered\|forwarded\|deferred\|bounced\|rejected\|held\|discarded\|reject_warnings" | tr -s " " > ${TMPDAT}
        else
            #show "Getting data from full log to result file..."
            cat /var/log/maillog | pflogsumm --detail 0 | sed 's/^[ \t]*//g;s/bytes received/bytes_received/;s/bytes delivered/bytes_delivered/g' | grep "^[0-9km]\+" | grep "received\|delivered\|forwarded\|deferred\|bounced\|rejected\|held\|discarded\|reject_warnings" | tr -s " " > ${TMPDAT}
        fi
    fi
    echo ${CURRENTPOS} >> ${TMPDAT}
}

getstatfromcache(){
    if [ -f ${TMPDAT} ]; then
        RESULT=`cat ${TMPDAT} | grep " $1" | cut -d' ' -f1 | awk '/k|m/{p = /k/?1:2}{printf "%d\n", int($1) * 1024 ^ p}'`
        if [ "${RESULT}" != "" ]; then
            echo ${RESULT}
        else
            echo 0
        fi
    else
        echo 0
    fi
    exit 0
}

main() {
    if [ $# -ne 1 ];then
        usage
        exit 1
    fi
 
    #lockfile -r 0 ${LOCK} || exit 1
#    lockfile -r 0 ${LOCK} 2> /dev/null || getstatfromcache $1
#        #touch ${LOCK}
#        echo $$ > ${LOCK}
#
#        if [ -f ${TMPDAT} ];then
#            TDIFF=$((`date +"%s"` - `date -r ${TMPDAT} +'%s'`))
#        else
#            TDIFF=`expr ${CACHE} + 1`
#        fi
#        if [ ${TDIFF} -gt ${CACHE} ] && [ ! -f ${LOCK} ];then
#        if [ ${TDIFF} -gt ${CACHE} ];then
#            touch ${LOCK}
#            getstatfromlog
#            rm -f ${LOCK}
#        fi
#    rm -f ${LOCK}
    getstatfromcache $1

    #show "Getting data from result ... "
#    if [ -f ${TMPDAT} ];then
#        RESULT=`cat ${TMPDAT} | grep " $1" | cut -d' ' -f1 | awk '/k|m/{p = /k/?1:2}{printf "%d\n", int($1) * 1024 ^ p}'`
#        echo ${RESULT}
#    else
#        echo 0
#    fi
#    RESULT=`cat ${TMPDAT} | grep " $1" | cut -d' ' -f1 | awk '/k|m/{p = /k/?1:2}{printf "%d\n", int($1) * 1024 ^ p}'`
#    if [ "${RESULT}" == "" ];then
#        echo 0
#    else
#        echo ${RESULT}
#    fi
#    exit 0
}

###############################################################################

main "$@"
