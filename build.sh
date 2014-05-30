#!/bin/bash
#Credit to Jmz for this script
export PATH=~/android/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin:$PATH
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=arm-eabi-
rm output/system/lib/modules/*.ko
rm output/kernel/zImage
make clean
make mrproper
make zara_defconfig
make -j4
FILE=arch/arm/boot/zImage

if [ -f $FILE ];
then
mkdir output
mkdir output/kernel
mkdir output/system
mkdir output/system/lib
mkdir output/system/lib/modules
cp arch/arm/boot/zImage output/kernel/zImage
find . -name '*.ko' -exec cp {} output/system/lib/modules/  \;
git log --oneline --decorate > output/META-INF/com/google/android/aroma/changelogs.txt
cd output
NOW=$(date +"%m-%d-%y")
zip -r --exclude=*zip* HaydenZara_Kernel-"$NOW".zip *
else
echo "Something went wrong"
fi
