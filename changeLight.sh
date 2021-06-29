#!/sbin/bash

if [ $1 == + ]; then
	echo +
elif [ $1 == - ]; then
	echo -
else
	echo "错误的参数"
fi
