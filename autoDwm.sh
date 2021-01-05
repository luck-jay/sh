#!/bin/sh
# 启动窗口渲染器
compton &
# 加载键盘布局
~/sh/setXmodmap.sh &
# 显示系统时间
~/sh/printInfo.sh &
# 配置壁纸启动
nitrogen --restore
# 配置扩展屏显示
xrandr --output eDP-1 --right-of HDMI-1 --auto
#feh --randomize --bg-fill ~/image
# 配置java应用程序会出现的问题
wmname LG3D
# 配置触摸板
~/sh/touchpad.sh &
