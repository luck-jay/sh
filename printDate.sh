#!/bin/bash
ELECTRICITY="0%"
VOLUME="0%"
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
# 每过1秒刷新一次时间
while true;do
	getacpi
	getvolume
	xsetroot -name "VOL | $VOLUME | BAT | $ELECTRICITY | TIME $(date "+%Y-%m-%d %H:%M:%S")"
	sleep 1s
done
