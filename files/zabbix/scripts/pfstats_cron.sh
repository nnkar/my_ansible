#!/usr/bin/env bash

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

TMPDAT='/tmp/pfstats.dat'

#show "Getting number of lines ..."
CURRENTPOS=`awk 'END {print NR}' /var/log/maillog`
if [ -f ${TMPDAT} ];then
    FROMPOS=`tail -n 1 ${TMPDAT}`
else
    FROMPOS=""
fi
#show "Checking last position ..."
if [ "${FROMPOS}" != "" ];then
    if [ ${FROMPOS} -le ${CURRENTPOS} ];then
        #show "Getting data from log to result file ..."
        tail -n +${FROMPOS} /var/log/maillog | pflogsumm --detail 0 | sed 's/^[ \t]*//g;s/bytes received/bytes_received/;s/bytes delivered/bytes_delivered/g' | grep "^[0-9km]\+" | grep "received\|delivered\|forwarded\|deferred\|bounced\|rejected\|held\|discarded\|reject_warnings" | tr -s " " > ${TMPDAT}
    else
        #show "Getting data from full log to result file..."
        cat /var/log/maillog | pflogsumm --detail 0 | sed 's/^[ \t]*//g;s/bytes received/bytes_received/;s/bytes delivered/bytes_delivered/g' | grep "^[0-9km]\+" | grep "received\|delivered\|forwarded\|deferred\|bounced\|rejected\|held\|discarded\|reject_warnings" | tr -s " " > ${TMPDAT}
    fi
fi
mailq=`mailq | grep Request. | awk '{print $5}'`
if [ "${mailq}" == "" ];then 
  mailq=0
fi
echo "${mailq} mailq" >> ${TMPDAT}
echo ${CURRENTPOS} >> ${TMPDAT}
