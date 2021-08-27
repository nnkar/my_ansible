#!/bin/bash

pt="/opt/ansible/files/ipset-sync/"
f1="ipset-tmp"
f2="ipset"
f3="sshban_ip"

str1="create -! sshban hash:ip family inet hashsize 4096 maxelem 65536"
str2="add -! sshban"

str3="create -! wlist hash:ip family inet hashsize 4096 maxelem 65536"
str4="add -! wlist"

echo -n > ${pt}${f3}

tmp1=$( cat ${pt}${f1} | grep "sshban" | sed '1d' | sed 's/\-\! //g' | awk '{print $3}' )
tmp2=$( cat ${pt}${f2} | grep "sshban" | sed '1d' | sed 's/\-\! //g' | awk '{print $3}' )
tmp="${tmp1} ${tmp2}"
xxx=$( echo ${tmp} | sed 's/ /\n/g' | sort | uniq )

# записываем sshban в файл ipset
echo ${str1} > ${pt}${f2}
for i in ${xxx}
do
 echo "${str2} ${i}" >> ${pt}${f2}
 echo "${i}" >> ${pt}${f3}
done;

echo -n > ${pt}${f1}

