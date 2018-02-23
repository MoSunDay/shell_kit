#!/bin/bash
function init(){
	User=$1
	Password=$2
	Port=$3
	DsaUserFile='/home/$User/.ssh/id_dsa'
	DsaRootFile='/root/.ssh/id_dsa'
	DsaFile='/home/$User/.ssh/id_dsa'
#   Range01="192.168.11."
#   Range02="192.168.12."
#   AllHostRange=(${Range01} ${Range02})
    if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" -o "$1" = '--help' -o "$1" = '-h' ];then
		echo "{USARG: $0 \$1 User \$2 password \$3 port \$4..\$n ip range}"
		exit -1
	elif [ $1 == 'root' ];then
	    DsaFile=${DsaRootFile}
	else
		DsaFile=${DsaUserFile}
	fi

	[ ! -f "${DsaFile}" ] && {
	    ssh-keygen -t dsa -P '' -f ${DsaFile}
	    ssh-add "${DsaFile}"
	}
}

function getRange(){
    AllHostRange=()
	for n in `seq 4 $#`
	do
		AllHostRange+=(${!n})
	done
}
function dochange(){
    for ((index = 0; index < "${#AllHostRange[*]}"; index++ ))
    do
        for n in seq {1..254}
        do
        {
            ping -w 1 -c 1 ${AllHostRange[index]}.${n} &>/dev/null
            if [ $? -eq 0 ];then
                expect fenfakey.exp ${AllHostRange[index]}.${n} ${User} ${Password} ${Port} &>/dev/null
                echo "fenfakey.exp ${AllHostRange[index]}.${n} ${User} ${Password} ${Port}"

            fi
        }&
        done
    done
}

function main(){
    init $*
    getRange $*
    dochange
}
main $*