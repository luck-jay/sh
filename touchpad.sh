#!/bin/bash
# 获取触摸板信息,如果没有获取到触控板则推出这个脚本
DATA=$(xinput list | grep Touchpad) || exit 1
DATA=${DATA##*=}
touchpad=${DATA%%\[*}
# 获取需要设置的属性id
DATA=$(xinput list-props $touchpad | grep -v Default | grep 'Tapping Enabled')
DATA=${DATA##*\(}
# 获取到设置触控板点击有效的id
TAP_EN_ID=${DATA%%)*}

DATA=$(xinput list-props $touchpad | grep -v Default | grep 'Scrolling Enabled')
DATA=${DATA##*\(}
# 获取到设置触控板自然滚动的id
SCR_EN_ID=${DATA%%)*}
# 设置触摸板
xinput set-prop $touchpad $TAP_EN_ID 1
xinput set-prop $touchpad $SCR_EN_ID 1
