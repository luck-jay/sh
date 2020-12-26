#!/bin/bash
requst=$(ps -ax | grep -v grep | grep trayer)
if [ $requst="" ]; then
	trayer &
else
	killall trayer
fi
