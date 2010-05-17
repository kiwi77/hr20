#!/bin/bash
#
#

# Define here you ip addresses:
HR20ipAddress="10.40.1.31"
ZBusGatewayIP=10.0.0.94

#
#

if test ! -d ./backup ; then mkdir ./backup ; fi

cp hr20.src ./backup/hr20.src_old_$(date +%s)		&&
cd ../ethersex						&&
make clean						&&
make							&&
cd -							&&
cd ../zbusloader/					&&
make clean						&&
make							&&
cd -							&&

Error=$? ; if [ $Error != 0 ] ; then exit 1 ; fi

if test ! -z "${HR20ipAddress}" ; then
	echo "bootloader" | socat stdio tcp4:${HR20ipAddress}:2701,connect-timeout=4
fi
if test ! -z "${ZBusGatewayIP}" ; then
	while true ; do
		../zbusloader/contrib/zbusloader -p 128 -t 5 -H ${ZBusGatewayIP} -f ../ethersex/ethersex.bin ; Error=$?
		if [ ${Error} = 0 ] ; then break ; fi
		if test ! -z "${HR20ipAddress}" ; then
			echo "bootloader" | socat stdio tcp4:${HR20ipAddress}:2701,connect-timeout=4
		else
			exit 1
		fi
	done
	if test ! -z "${HR20ipAddress}" ; then
		echo "Waiting 10 seconds to boot the HR20"
		sleep 10
		date +"time "%s | socat stdio tcp4:${HR20ipAddress}:2701,connect-timeout=4
	fi
fi
# view free space on chip, and clean it things...
cd ../ethersex						&&
make							&&
make clean						&&
cd -

