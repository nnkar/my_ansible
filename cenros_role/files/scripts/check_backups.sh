#!/bin/bash

# Script for checking ProxMox virtual machines backup. For use in Zabbix. Skygge@2016

#Variables

backupconfig='/etc/pve/vzdump_manual'
storageconfig='/etc/pve/storage.cfg'
configdir='/etc/pve/local/qemu-server'
error=0

# Virtual machines with onboot=yes
virtualmachines=`find $configdir -type f -name "*.conf" -exec grep -H 'onboot' {} \;|cut -d ":" -f 1|cut -d "/" -f 6|cut -d "." -f 1`

# Backup Configuration for VM's
backupallmachines=`grep '\-\-all' $backupconfig|wc -l`


# Check every VM for configured backup
if [ "$backupallmachines" = "0" ]; then
 for i in $virtualmachines
 do
    checkbackup=`grep $i $backupconfig |sed 's/  */ /g'|cut -d "-" -f 1|cut -d " " -f 8-|tr -d "\n"`
    if [ "$checkbackup" = "" ];then
        echo "VM $i is not configured for backups."
        error=1
    fi
 done
fi

# Check every VM for existing backup files and check if they're newer than 7 days
for k in $virtualmachines
do
        parameters=`cat $backupconfig |egrep "($k|\-\-all)"|head -1|sed 's/  */ /g'`

        if [ "$parameters" = "" ];then
            backup=0
            error=1
        else
            #read backup configuration file into an array and find the backup storage parameter
            IFS=' ' read -r -a array <<< "$parameters"
            for index in "${!array[@]}"
            do
                    if [ "${array[index]}" = "--storage" ]; then
                        z=$((index+1))
                        backupstorage=${array[$z]}
                    fi
            done
        # read physical backup path from storage configuration file for VM $k
        backupdirectory=`cat $storageconfig|grep -E "$backupstorage$"|grep path|rev|cut -d " " -f 1|rev`
        if [ -d $backupdirectory/dump ]; then
                # check if backup file(s) exists on backup path for VM $k
                backup=`ls $backupdirectory/dump/|grep $k|grep -v log|wc -l`
                if [ "$backup" = "0" ]; then
                      echo "VM $k has no backup file."
                      error=1
                else
                # check if backup file is newer than 7 days for VM $k
                newbackup=`find $backupdirectory/dump/ -type f -name "*$k*" -not -name "*.log" -mtime -30 | sort -nr | head -1|wc -l`
                    if [ "$newbackup" = "0" ]; then
                        echo "VM $k backup is older than 30 days."
                        error=1
                    fi
                fi
            else
                echo "backup directory for VM $k does not exists"
                backup=0
                error=1
        fi
        fi
done

if [ "$error" = "0" ]; then
echo "OK"
fi