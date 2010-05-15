#!/bin/bash
#
#

cd ..
git clone git://github.com/kiwi77/ethersex.git
git clone git://github.com/kiwi77/zbusloader.git
cd -
cp -v config.mk ../ethersex/config.mk
cp -v ./.config ../ethersex/.config
echo
echo
echo "For the next step, the \"make menuconfig\" from ethersex must run"
echo "after opening, you must go to \"< Exit >\" and"
echo "  Do you wish to save your new Ethersex configuration? --> \"< Yes >\""
echo
echo "Press Enter to continue"
echo
read
cd ../ethersex
make menuconfig
cd -



