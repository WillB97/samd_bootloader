#!/bin/bash -ex

# populate thirdparty
cd thirdparty
wget https://github.com/ARM-software/CMSIS/archive/refs/tags/v4.5.0.tar.gz -O - | tar -xz
wget https://github.com/adafruit/ArduinoModule-CMSIS-Atmel/releases/download/v1.2.1/CMSIS-Atmel-1.2.1.tar.bz2 -O - | tar -xz
cd ..
