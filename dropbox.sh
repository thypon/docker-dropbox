#!/bin/sh
/sbin/setuser docker /usr/bin/xpra start :10 --start-child=dropboxd --no-daemon

