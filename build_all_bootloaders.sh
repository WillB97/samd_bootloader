#!/bin/bash -ex

BOARD_ID=arduino_zero NAME=samd21_sam_ba make clean all

CHIPNAME=SAMD21E15 make clean all
CHIPNAME=SAMD21E16 make clean all
CHIPNAME=SAMD21E17 make clean all
CHIPNAME=SAMD21E18 make clean all

CHIPNAME=SAMD21G15 make clean all
CHIPNAME=SAMD21G16 make clean all
CHIPNAME=SAMD21G17 make clean all
CHIPNAME=SAMD21G18 make clean all

CHIPNAME=SAMD21J15 make clean all
CHIPNAME=SAMD21J16 make clean all
CHIPNAME=SAMD21J17 make clean all
CHIPNAME=SAMD21J18 make clean all

# Clean up build files
make clean

echo Done building bootloaders!
