#!/bin/bash

# состояние массива hdd

ContrStat=`/opt/compaq/hpacucli/bld/hpacucli ctrl all show status | grep "Controller Status" | awk -F":" '{print $2}'`
LocDrStat=`/opt/compaq/hpacucli/bld/hpacucli ctrl all show config | grep logicaldrive | sed -e 's/[(]//' -e 's/[)]//' | awk '{print $7}'`
PhysDrStat="OK"
PD=(`/opt/compaq/hpacucli/bld/hpacucli ctrl all show config | grep physicaldrive | sed -e 's/[(]//' -e 's/[)]//' | awk '{print $10}'`)

for item in ${PD[*]}
do
    if [[ $item = "OK" ]]
    then
	PhysDrStat="OK"
        #echo $item
    else
        PhysDrStat="PROBLEM"
        #echo $item
        break;
    fi
done

if (( $ContrStat != "OK" && $LocDrStat != "OK" && $PhysDrStat != "OK" ))
then
    echo 1
else
    echo 0
fi
