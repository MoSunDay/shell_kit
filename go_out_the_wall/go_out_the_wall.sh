#!/usr/bin/env bash

declare -a routes=('t_txt=c_HK' 't_txt=c_CN')
route_file_name='/dir/wall/iptables_file'
send_email="./mail.py"
result_flage=0
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -A PREROUTING -d 127.0.0.0/24 -j RETURN
sudo iptables -t nat -A PREROUTING -d 192.168.0.0/16 -j RETURN
sudo iptables -t nat -A PREROUTING -d 10.42.0.0/16 -j RETURN
sudo iptables -t nat -A PREROUTING -d 0.0.0.0/8 -j RETURN
sudo iptables -t nat -A PREROUTING -d 10.0.0.0/8 -j RETURN
sudo iptables -t nat -A PREROUTING -d 172.16.0.0/12 -j RETURN
sudo iptables -t nat -A PREROUTING -d 224.0.0.0/4 -j RETURN
sudo iptables -t nat -A PREROUTING -d 240.0.0.0/4 -j RETURN
sudo iptables -t nat -A PREROUTING -d 169.254.0.0/16 -j RETURN
sudo iptables -t nat -A PREROUTING -p tcp --dport 53 -j RETURN
sudo iptables -t nat -A PREROUTING -p udp --dport 53 -j RETURN
sudo iptables -t nat -A PREROUTING -p tcp -s localip  -j REDIRECT --to-ports 1080
sudo iptables -t nat -A PREROUTING -p udp -s localip  -j REDIRECT --to-ports 1080

for route in "${routes[@]}"
do
    curl --connect-timeout 15 -m 3 http://ipblock.chacuo.net/down/${route} 1>> ${route_file_name} 2> /dev/null
    if [ $? -ne 0 ];then
        result_flage=1
    fi
done

cat ${route_file_name}  | grep -v "pre" | awk -F '[ \t]' '{print $3}' | sed -n -r 's#(.*)#sudo iptables -t nat -I PREROUTING -d \1 -j RETURN#gp' | bash
[ $? -ne 0 ] && {
    result_flage=2
    >${route_file_name}
}

if [ ${result_flage} -eq 0 ];then
    python ${send_email} "update route" "success"
elif [ ${result_flage} -eq 1 ];then
    python ${send_email} "update route" "update route file faild"
elif [ ${result_flage} -eq 2 ];then
    python ${send_email} "update route" "update route rule faild"
fi