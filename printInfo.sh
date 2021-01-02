#!/bin/bash
ELECTRICITY="0%"
VOLUME="0%"
NET=""
# 更新当前电池信息
function getacpi(){
	DATA=$(acpi)
	DATASTATE=${DATA#*:}
	DATASTATE=${DATASTATE%%,*}
	DATA=${DATA#*,}
	ELECTRICITY=${DATA%%,*}
	ELECTRICITY=$ELECTRICITY" "$DATASTATE
}
# 更新当前音量
function getvolume(){
	DATA=$(amixer get Master | grep Mono)
	DATA=${DATA#*[}
	VOLUME=${DATA%%]*}
}
# 更新网络状态
function getinernet(){
	INTER=$(ip addr | grep -v lo | grep LOWER_UP)
	if [ -z "$INTER" ]; then
		NET="NO"
	else
		if [ ${INTER:3:1} = "e" ]; then
			NET="NET"
		elif [ ${INTER:3:1} = "w" ]; then
			NET="WIFI"
		else
			NET="WIFI"
		fi
	fi
}
# 每过1秒刷新一次时间
while true;do
	getacpi
	getvolume
	getinernet
	xsetroot -name "NET | $NET |VOL | $VOLUME | BAT | $ELECTRICITY | TIME $(date "+%Y-%m-%d %H:%M:%S")"
	sleep 1s
done
