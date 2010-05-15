#!/bin/bash
#
#


HR20ipAddress="10.40.1.31"
ZBusGatewayIP=10.0.0.94

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
if test ! -z "${HR20ipAddress}" ; then
	echo "bootloader" | socat stdio tcp4:10.40.1.31:2701
fi
if test ! -z "${ZBusGatewayIP}" ; then
	../zbusloader/contrib/zbusloader -H ${ZBusGatewayIP} -f ../ethersex/ethersex.bin
	if test ! -z "${HR20ipAddress}" ; then
		echo "Waiting 10 seconds to boot the HR20"
		sleep 10
		date +"time "%s | socat stdio tcp4:${HR20ipAddress}:2701
	fi
fi
# view free space on chip, and clean it things...
cd ../ethersex						&&
make							&&
make clean						&&
cd -

