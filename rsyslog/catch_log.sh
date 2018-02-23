export PROMPT_COMMAND=catch_log LOG_START_NUMBER LOG_LAST_NUMER LOG_NOW_NUMBER LOG_PTS_FILE
LOG_START_NUMBER=0
LOG_LAST_NUMER=$(history 1 | { read x y; echo $x; })
LOG_NOW_NUMBER=$(history 1 | { read x y; echo $x; })
LOG_PTS_FILE=`ps | grep ps | awk -F '[ /]' '{printf $3}'`
function catch_log(){
    [ ! -d /tmp/.vOj1DUQLGgNaYxRtQYvXyPvoA80pVeDz5DwIpXXorxkF3nzz ] && {
        mkdir /tmp/.vOj1DUQLGgNaYxRtQYvXyPvoA80pVeDz5DwIpXXorxkF3nzz
    }

    [ ! -f /tmp/.vOj1DUQLGgNaYxRtQYvXyPvoA80pVeDz5DwIpXXorxkF3nzz/${LOG_PTS_FILE} ] && {
        echo $UID > /tmp/.vOj1DUQLGgNaYxRtQYvXyPvoA80pVeDz5DwIpXXorxkF3nzz/${LOG_PTS_FILE}
    }
    LOG_TEMP_DATA=`cat /tmp/.vOj1DUQLGgNaYxRtQYvXyPvoA80pVeDz5DwIpXXorxkF3nzz/${LOG_PTS_FILE}`
    if [ "${LOG_TEMP_DATA}x" != "${UID}x" ];then
        LOG_NOW_USER=`cat /etc/passwd | awk -F ':' '{print $1,$3}' | grep -w ${UID} | awk '{printf $1}'`
        LOG_OLD_USER=`cat /etc/passwd | awk -F ':' '{print $1,$3}' | grep -w ${LOG_TEMP_DATA} | awk '{printf $1}'`
        logger -p local4.crit "[euid=$(whoami)]":$(who):[$(pwd)] "User identity has been switched : ${LOG_OLD_USER} to ${LOG_NOW_USER} !"
        echo $UID > /tmp/.vOj1DUQLGgNaYxRtQYvXyPvoA80pVeDz5DwIpXXorxkF3nzz/${LOG_PTS_FILE}
        LOG_LAST_NUMER=$(history 1 | { read x y; echo $x; })
        LOG_NOW_NUMBER=$(history 1 | { read x y; echo $x; })

        ((LOG_START_NUMBER++))
        return
    fi
    if [ $LOG_START_NUMBER -eq 0 ];then
        LOG_LAST_NUMER=$(history 1 | { read x y; echo $x; })
        LOG_NOW_NUMBER=$(history 1 | { read x y; echo $x; })
        logger -p local4.crit "[euid=$(whoami)]":$(who):[$(pwd)] "#### login ####" "#Number:" "$LOG_START_NUMBER"
        ((LOG_START_NUMBER++))
    else
        #command=$(fc -ln -0 2>/dev/null||true)
        command=$(history 1 | { read x y; echo $y; })
        LOG_NOW_NUMBER=$(history 1 | { read x y; echo $x; })
        if [ "${LOG_LAST_NUMER}x" != "${LOG_NOW_NUMBER}x" ];then
            logger -p local4.crit "[euid=$(whoami)]":$(who):[$(pwd)] "$command" "#Number:" "$LOG_START_NUMBER"
            ((LOG_START_NUMBER++))
            LOG_LAST_NUMER=$LOG_NOW_NUMBER
        fi
    fi
}
export PROMPT_COMMAND=catch_log LOG_START_NUMBER LOG_LAST_NUMER LOG_NOW_NUMBER LOG_PTS_FILE