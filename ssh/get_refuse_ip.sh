#!/bin/bash

function usage_options(){

cat <<EOF

Usage:
    $0 [install uninstall null]

Description:
    -h, --help
                print usage or some help infomations.

    install
                add auto run to ~/.bashrc

    uninstall
                remove ~/.bashrc content (It will be backed up before this )

    clean
                empty log file  (It will be backed up before this )

    null
                print reports without parameters

Example:

    $0 install
    $0
    $0 clean
    $0 uninstall

Note:

    The current user must have sudo permissions

EOF
}

function init(){
    source /etc/bashrc >/dev/null 2>&1
    source /etc/profile  >/dev/null 2>&1

    LOG_FILE_PATH="/var/log/auth.log"

    red_color='\E[1;31m'
    green_color='\E[1;32m'
    yellow_color='\E[1;33m'
    blue_color='\E[1;34m'
    purple_color='\E[1;35m'
    end_color='\E[0m'

    get_ip_result=`sudo cat "${LOG_FILE_PATH}" | grep ': Failed password' | grep -Po "for .*" | egrep -v "invalid user" | awk '{print $2, $4}' | sort  | uniq -c | sort -nr 2>/dev/null`
}

function null_to_print(){
    echo -e "${green_color} don't have refuse ip. ${end_color}"
}

function echo_red_color(){
    echo -e "${red_color} $* ${end_color}"
}

function echo_green_color(){
    echo -e "${green_color} $* ${end_color}"
}

function echo_yellow_color(){
    echo -e "${yellow_color} $* ${end_color}"
}

function echo_bule_color(){
    echo -e "${blue_color} $* ${end_color}"
}

function echo_purple_color(){
    echo -e "${purple_color} $* ${end_color}"
}

function get_ip_info(){
    ip_info_report=`curl -s --connect-timeout 2 ipinfo.io/$1`
    echo "${ip_info_report}"
}

function get_refuese_ip_report(){
    if [ -f "${LOG_FILE_PATH}" -a "${get_ip_result}x" != "x" ];then
        echo "${get_ip_result}" | while read line
        do
            ip_refuse_number=`echo ${line} | awk '{print $1}'` 2> /dev/null
            ip_addr=`echo ${line} | awk '{print $3}'` 2> /dev/null
            ip_info_report=`get_ip_info ${ip_addr}`
            if [ "${ip_refuse_number}x" == "x" ];then
                null_to_print
                exit 2
            elif [ ${ip_refuse_number} -gt 500 ];then
                echo_red_color ${line} " \n\n" ${ip_info_report} "\n\n"
            elif [ ${ip_refuse_number} -gt 300 ];then
                echo_purple_color ${line} " \n\n" ${ip_info_report} "\n\n"
            elif [ ${ip_refuse_number} -gt 10 ];then
                echo_yellow_color ${line} " \n\n" ${ip_info_report} "\n\n"
            else
                echo_bule_color ${line} " \n\n" ${ip_info_report} "\n\n"
            fi
        done
    else
        null_to_print
        exit 1
    fi
}

function install_refuses_ip_script(){
    script_path=`readlink -f $0`
    path_bin=`dirname ${script_path}`
    chmod a+x ${script_path}
    echo -e "timeout 3 bash ${script_path} #FW1aZPqEzu7eRMDTVtw23EPlRu5tZmMAEft6Groo4u9DnaxlwCooqxrBvsPD3l4S\nexport PATH=\"${path_bin}:$PATH\" #FW1aZPqEzu7eRMDTVtw23EPlRu5tZmMAEft6Groo4u9DnaxlwCooqxrBvsPD3l4S" >> ~/.bashrc
}

function uninstall_refuses_ip_script(){
    cp ~/.bashrc{,.bak}
    sed -i "/FW1aZPqEzu7eRMDTVtw23EPlRu5tZmMAEft6Groo4u9DnaxlwCooqxrBvsPD3l4S/d" ~/.bashrc
}

function clean_refuese_ip_log(){
    sudo cp "${LOG_FILE_PATH}"{,.`date "+%F_%H:%M:%S"`}
    echo "" | sudo tee ${LOG_FILE_PATH}
}

function main(){
    init
    case "$1" in
        install)      install_refuses_ip_script;;
        uninstall)    uninstall_refuses_ip_script;;
        clean)        clean_refuese_ip_log;;
        -h|--help)    usage_options;;
        *)            get_refuese_ip_report;;
    esac
}

main $*

# Last login: Thu Feb  8 19:06:49 2018 from x.x.x.x
#
# 636 root 182.100.67.252
#
# { "ip": "182.100.67.252", "city": "Lianxi", "region": "Jiangxi", "country": "CN", "loc": "28.5556,115.9120", "org": "AS4134 CHINANET-BACKBONE" }
#
#
# 540 root 182.100.67.129
#
# { "ip": "182.100.67.129", "city": "Lianxi", "region": "Jiangxi", "country": "CN", "loc": "28.5556,115.9120", "org": "AS4134 CHINANET-BACKBONE" }
#
#
# 60 root 116.196.116.76
#
# { "ip": "116.196.116.76", "city": "Beijing", "region": "Beijing", "country": "CN", "loc": "39.9289,116.3883", "org": "AS4808 China Unicom Beijing Province Network" }
#
#
# 28 root 115.238.245.4
#
# { "ip": "115.238.245.4", "city": "Ningbo", "region": "Zhejiang", "country": "CN", "loc": "29.8782,121.5490", "org": "AS4134 CHINANET-BACKBONE", "postal": "315207" }
#
#
# 26 root 115.238.245.6
#
# { "ip": "115.238.245.6", "city": "Ningbo", "region": "Zhejiang", "country": "CN", "loc": "29.8782,121.5490", "org": "AS4134 CHINANET-BACKBONE", "postal": "315207" }
#
#
# 16 root 122.226.181.166
#
# { "ip": "122.226.181.166", "city": "Wenzhou", "region": "Zhejiang", "country": "CN", "loc": "27.9994,120.6670", "org": "AS4134 CHINANET-BACKBONE", "postal": "325300" }
#
#
# 12 root 122.226.181.165
#
# { "ip": "122.226.181.165", "city": "Wenzhou", "region": "Zhejiang", "country": "CN", "loc": "27.9994,120.6670", "org": "AS4134 CHINANET-BACKBONE", "postal": "325300" }
#
#
# 12 root 122.226.181.164
#
# { "ip": "122.226.181.164", "city": "Wenzhou", "region": "Zhejiang", "country": "CN", "loc": "27.9994,120.6670", "org": "AS4134 CHINANET-BACKBONE", "postal": "325300" }
#
#
# 6 root 27.38.122.166
#
# { "ip": "27.38.122.166", "city": "Shenzhen", "region": "Guangdong", "country": "CN", "loc": "22.5333,114.1333", "org": "AS17623 China Unicom Shenzen network" }
#
#
# 6 root 122.226.181.167
#
# { "ip": "122.226.181.167", "city": "Wenzhou", "region": "Zhejiang", "country": "CN", "loc": "27.9994,120.6670", "org": "AS4134 CHINANET-BACKBONE", "postal": "325300" }
#
#
# 4 root 58.53.219.75
#
# { "ip": "58.53.219.75", "city": "Yingcheng", "region": "Hubei", "country": "CN", "loc": "30.9500,113.5500", "org": "AS4134 CHINANET-BACKBONE" }
#
#
# 2 root 61.153.56.30
#
# { "ip": "61.153.56.30", "city": "Jiaxing", "region": "Zhejiang", "country": "CN", "loc": "30.7522,120.7500", "org": "AS4134 CHINANET-BACKBONE", "postal": "314000" }
#
#
# 2 root 218.65.30.25
#
# { "ip": "218.65.30.25", "hostname": "25.30.65.218.broad.xy.jx.dynamic.163data.com.cn", "city": "Nanchangshi", "region": "Jiangxi", "country": "CN", "loc": "28.6558,115.9050", "org": "AS4134 CHINANET-BACKBONE" }