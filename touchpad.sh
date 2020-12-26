#!/bin/bash
# 获取触摸板信息
DATA=$(xinput list | grep Touchpad)
DATA=${DATA##*=}
touchpad=${DATA%%\[*}
# 设置触摸板
xinput set-prop $touchpad 334 1
xinput set-prop $touchpad 314 1
