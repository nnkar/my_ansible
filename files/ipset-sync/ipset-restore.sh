#!/bin/bash

fipsSshban="/tmp/ipset"
IPS=`which ipset`

${IPS} restore < ${fipsSshban}

if [ -f /etc/ipset/ipset ]
then 
    fips="/etc/ipset/ipset"
else
    fips="/etc/ipset"
fi
        
${IPS} save > ${fips}
