#!/bin/sh
ELECTRICITY="0%"
VOLUME="0%"
NET=""
SPEED="RX:0B TX:0B"
# 更新当前电池信息
function getacpi(){
	DATA=$(acpi)
	DATASTATE=${DATA#*:}
	DATASTATE=${DATASTATE%%,*}
	DATA=${DATA#*,}
	ELECTRICITY=${DATA%%,*}
	ELECTRICITY=${ELECTRICITY:1}""$DATASTATE
}
# 更新当前音量
function getvolume(){
	DATA=$(amixer get Master | grep Mono)
	DATA=${DATA#*[}
	VOLUME=${DATA%%]*}
}
# 更新当前网速
function getspeed(){
	DATA=$(ip -s link | awk '{print $1,$2}' | grep -A 5 $1 | grep -A 1 bytes)
	RX1=$(echo $DATA | awk '{print $3}')
	TX1=$(echo $DATA | awk '{print $7}')
	sleep 1s
	# 第二次获得数据包
	DATA=$(ip -s link | awk '{print $1,$2}' | grep -A 5 $1 | grep -A 1 bytes)
	RX2=$(echo $DATA | awk '{print $3}')
	TX2=$(echo $DATA | awk '{print $7}')
	# 计算网速
	RX=$(expr $RX2 - $RX1)
	TX=$(expr $TX2 - $TX1)
	# 计算下行流量
	if [ $RX -lt 1024 ]; then
		RX=$RX"B/s"
	elif [ $RX -lt 1048576 ]; then
		RX=$(expr $RX / 1024)"K/s"
	else
		RX=$(echo "scale=1; $RX / 1048576" | bc)"M/s"
	fi
	# 计算上行流量
	if [ $TX -lt 1024 ]; then
		TX=$TX"B/s"
	elif [ $TX -lt 1048576 ]; then
		TX=$(expr $TX / 1024)"K/s"
	else
		TX=$(echo "scale=1; $TX / 1048576" | bc)"M/s"
	fi

	SPEED="RX:$RX TX:$TX"
}
# 更新网络状态
function getinernet(){
	# 获取网卡名称
	INTER=$(ip addr | grep -v lo | grep LOWER_UP | awk '{print $2}')
	I1=${INTER%%:*}
	I2=${INTER#*:}
	I2=${I2%:*}
	# 如果有多个网卡获取网卡名称的规则
	if [ $I2  ]; then
		INTER=${I2:1}
	elif [ $I1 ]; then
		INTER=$I1
	else
		INTER=""
	fi
	# 判断网卡类型
	if [ -z "$INTER" ]; then
		NET="No"
	else
		if [ "${INTER:0:1}" = "e" ]; then
			NET="Ethernet"
		elif [ "${INTER:0:1}" = "w" ]; then
			NET="Wifi"
		else
			NET="No"
		fi
		# 计算实时网速
		getspeed $INTER
	fi
}
# 每过1秒刷新一次时间
while true; do
	getacpi
	getvolume
	xsetroot -name "$SPEED|NET:$NET|VOL:$VOLUME|BAT:$ELECTRICITY|$(date "+%Y-%m-%d %H:%M:%S")"
	getinernet
done
