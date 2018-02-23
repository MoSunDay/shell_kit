#!/usr/bin/env bash
# on shell
# need net-tool
# while true;do for interface in `ifconfig | awk -F '[ ]' '{print $1}' | egrep -v "^$" | awk -F ':' '{print $1}'`;do ifconfig ${interface} | egrep "RX packets|TX packets" | awk -F '[: ]+' '{print $4}' | tr '\n'  ' ' | { read rx_pack tx_pack; sleep 1; echo "" ; ifconfig ${interface} | egrep "RX packets|TX packets" | awk -F '[: ]+' '{print $4}' | tr '\n'  ' ' | awk '{printf "## %s -> rx: %d tx: %d\n", "'$interface'", $1 - '$rx_pack', $2 - '$tx_pack'}'; };done;done;
# don't need net-tool
    # while true;do for interface in `cat /proc/net/dev | awk 'BEGIN{NR=2}{print $1}' | egrep -v "Inter|face" | awk -F ':' '{print $1}'`;do cat /proc/net/dev | grep "${interface}" | awk -F '[ ]+' '{print $4, $12}' | { read rx_pack tx_pack; sleep 1; echo ""; cat /proc/net/dev | grep "${interface}" | awk -F '[ ]+' '{print $4, $12}' | awk '{printf "## %s -> rx: %d tx: %d\n", "'$interface'", $1 - "'$rx_pack'", $2 - "'$tx_pack'"}'; };done;done;

function usage(){
cat <<EOF
    network_package_speed [ -n | -i ]

Description:
    -h, --helpruguo
                print usage or some help infomations.

    -n, --name
                print all network card name.

    -i, --inter
                specified network card name.

Example:

    network_package_speed
    network_package_speed -n
    network_package_speed -i eth0 lo
EOF
}

function all_interface(){
    for interface in `ifconfig | awk -F '[ ]' '{print $1}' | egrep -v "^$" | awk -F ':' '{print $1}'`
    do
        {
           ifconfig ${interface} | egrep "RX packets|TX packets" | awk -F '[: ]+' '{print $4}' | tr '\n'  ' ' | { read rx_pack tx_pack; sleep 1; echo ""; ifconfig ${interface} | egrep "RX packets|TX packets" | awk -F '[: ]+' '{print $4}' | tr '\n'  ' ' | awk '{printf "## %s -> rx: %d tx: %d\n", "'$interface'", $1 - '$rx_pack', $2 - '$tx_pack'}'; } 2>/dev/null || echo "interface don't exit" &
        }
        sleep 0.1
    done
}

function options_interface(){
    for interface in "$@"
    do
        {
           ifconfig ${interface} | egrep "RX packets|TX packets" | awk -F '[: ]+' '{print $4}' | tr '\n'  ' ' | { read rx_pack tx_pack; sleep 1; echo ""; ifconfig ${interface} | egrep "RX packets|TX packets" | awk -F '[: ]+' '{print $4}' | tr '\n'  ' ' | awk '{printf "## %s -> rx: %d tx: %d\n", "'$interface'", $1 - '$rx_pack', $2 - '$tx_pack'}'; } 2>/dev/null || echo "interface don't exit" &
        }
        sleep 0.1
    done
}

case $1 in
    '')             all_interface;;
    -n|name)        ifconfig | awk -F '[ ]' '{print $1}' | egrep -v "^$";;
    -i|--inter)     shift 1; options_interface $*;;
    *)              usage;;
esac