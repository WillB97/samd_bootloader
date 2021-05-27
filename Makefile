# Copyright (c) 2015 Atmel Corporation/Thibaut VIARD.  All right reserved.
# Copyright (c) 2015 Arduino LLC.  All right reserved.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

# -----------------------------------------------------------------------------
# Paths
ifeq ($(OS),Windows_NT)
  # Are we using mingw/msys/msys2/cygwin?
  ifeq ($(TERM),xterm)
    T=$(shell cygpath -u $(LOCALAPPDATA))
    ARM_GCC_PATH?=$(T)/Arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin/arm-none-eabi-
    RM=rm
    SEP=/
  else
    ARM_GCC_PATH?=$(LOCALAPPDATA)/Arduino15/packages/arduino/tools/arm-none-eabi-gcc/7-2017q4/bin/arm-none-eabi-
    RM=rm
    SEP=\\
  endif
else
  UNAME_S := $(shell uname -s)

  ifeq ($(UNAME_S),Linux)
    ARM_GCC_PATH?=/usr/bin/arm-none-eabi-
    RM=rm
    SEP=/
  endif

  ifeq ($(UNAME_S),Darwin)
    ARM_GCC_PATH?=/usr/local/bin/arm-none-eabi-
    RM=rm
    SEP=/
  endif
endif

MODULE_PATH?=$(abspath $(CURDIR)/thirdparty)
BUILD_PATH=build
OUTPUT_PATH=out

# -----------------------------------------------------------------------------
# Tools
CC=$(ARM_GCC_PATH)gcc
OBJCOPY=$(ARM_GCC_PATH)objcopy
NM=$(ARM_GCC_PATH)nm
SIZE=$(ARM_GCC_PATH)size

# -----------------------------------------------------------------------------
CHIPNAME?=SAMD21G18
include chipname.mk

# Boards definitions
BOARD_ID?=arduino_zero
NAME?=$(CHIPNAME_L)_sam_ba

# -----------------------------------------------------------------------------
# Compiler options
SAM_BA_INTERFACES?=SAM_BA_BOTH_INTERFACES
CFLAGS_EXTRA=-D$(CHIP_DEF) -DBOARD_ID_$(BOARD_ID) -D$(SAM_BA_INTERFACES)
CFLAGS=-mthumb -mcpu=cortex-m0plus -Wall -c -std=gnu99 -ffunction-sections -fdata-sections -nostdlib -nostartfiles --param max-inline-insns-single=500
ifdef DEBUG
  CFLAGS+=-g3 -O1 -DDEBUG=1
else
  CFLAGS+=-Os -DDEBUG=0 -flto
endif

ifdef SECURE_BY_DEFAULT
  CFLAGS+=-DSECURE_BY_DEFAULT=1
endif

ELF=$(NAME).elf
BIN=$(NAME).bin
HEX=$(NAME).hex

INCLUDES=-I"$(MODULE_PATH)/CMSIS-4.5.0/CMSIS/Include/" -I"$(MODULE_PATH)/CMSIS-Atmel/CMSIS-Atmel/CMSIS/Device/ATMEL/"

# -----------------------------------------------------------------------------
# Linker options
LDFLAGS=-mthumb -mcpu=cortex-m0plus -Wall -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all
LDFLAGS+=-Wl,--warn-common -Wl,--warn-section-align -Wl,--warn-unresolved-symbols --specs=nano.specs --specs=nosys.specs

# -----------------------------------------------------------------------------
# Source files and objects
SOURCES= \
  board_driver_led.c \
  board_driver_jtag.c \
  board_driver_serial.c \
  board_driver_usb.c \
  board_init.c \
  board_startup.c \
  main.c \
  sam_ba_usb.c \
  sam_ba_cdc.c \
  sam_ba_monitor.c \
  sam_ba_serial.c

OBJECTS=$(addprefix $(BUILD_PATH)/, $(SOURCES:.c=.o))
DEPS=$(addprefix $(BUILD_PATH)/, $(SOURCES:.c=.d))

ifneq "test$(AVRSTUDIO_EXE_PATH)" "test"
  AS_BUILD=copy_for_atmel_studio
  AS_CLEAN=clean_for_atmel_studio
else
  AS_BUILD=
  AS_CLEAN=
endif

all: print_info $(SOURCES) $(BIN) $(HEX) $(AS_BUILD)

$(ELF): Makefile $(BUILD_PATH) $(OBJECTS)
	@echo ----------------------------------------------------------
	@echo Creating ELF binary
	"$(CC)" -L. -L$(BUILD_PATH) $(LDFLAGS) -Os -Wl,--gc-sections -save-temps -T$(LD_SCRIPT) -Wl,-Map,"$(BUILD_PATH)/$(NAME).map" -o "$(BUILD_PATH)/$(ELF)" -Wl,--start-group $(OBJECTS) -lm -Wl,--end-group
	"$(NM)" "$(BUILD_PATH)/$(ELF)" >"$(BUILD_PATH)/$(NAME)_symbols.txt"
	"$(SIZE)" --format=sysv -t -x $(BUILD_PATH)/$(ELF)

$(BIN): $(ELF) $(OUTPUT_PATH)
	@echo ----------------------------------------------------------
	@echo Creating flash binary
	"$(OBJCOPY)" -O binary $(BUILD_PATH)/$< $(OUTPUT_PATH)/$@

$(HEX): $(ELF) $(OUTPUT_PATH)
	@echo ----------------------------------------------------------
	@echo Creating flash binary
	"$(OBJCOPY)" -O ihex $(BUILD_PATH)/$< $(OUTPUT_PATH)/$@

$(BUILD_PATH)/%.o: %.c
	@echo ----------------------------------------------------------
	@echo Compiling $< to $@
	"$(CC)" $(CFLAGS) $(CFLAGS_EXTRA) $(INCLUDES) $< -o $@
	@echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

$(BUILD_PATH):
	@echo ----------------------------------------------------------
	@echo Creating build folder
	-mkdir $(BUILD_PATH)

$(OUTPUT_PATH):
	@echo ----------------------------------------------------------
	@echo Creating output folder
	-mkdir $(OUTPUT_PATH)

print_info:
	@echo ----------------------------------------------------------
	@echo Compiling bootloader using
	@echo BASE PATH = $(MODULE_PATH)
	@echo GCC  PATH = $(ARM_GCC_PATH)
	@echo CHIP NAME = $(CHIPNAME_U)
	@echo LD_SCRIPT = $(LD_SCRIPT)
#	@echo OS        = $(OS)
#	@echo SHELL     = $(SHELL)
#	@echo TERM      = $(TERM)
#	"$(CC)" -v
#	env

size:
	@echo ----------------------------------------------------------
	@echo Size for $(CHIPNAME_U)
	@"$(SIZE)" $(BUILD_PATH)/$(ELF) | awk -v maxflash=$(FLASH_SIZE) -v maxram=$(RAM_SIZE) '(NR==2){ \
		flash=$$1+$$2; \
		ram=$$2+$$3; \
		print $$6; \
		printf "Flash used: %d / %d (%0.2f%%)\n", flash, maxflash, flash / maxflash * 100; \
		printf "RAM used: %d / %d (%0.2f%%)\n", ram, maxram, ram / maxram * 100 \
	}'

copy_for_atmel_studio: $(BIN) $(HEX)
	@echo ----------------------------------------------------------
	@echo Atmel Studio detected, copying ELF to output folder for debug
	cp $(BUILD_PATH)/$(ELF) $(OUTPUT_PATH)/

clean_for_atmel_studio:
	@echo ----------------------------------------------------------
	@echo Atmel Studio detected, cleaning ELF from output folder
	-$(RM) $(OUTPUT_PATH)/$(ELF)

clean: $(AS_CLEAN)
	@echo ----------------------------------------------------------
	@echo Cleaning project
	-$(RM) $(BUILD_PATH)/*.*
	-$(RM) *.elf.ltrans.out
	-$(RM) *.elf.ltrans0.ltrans.o
	-$(RM) *.elf.ltrans0.o
	-$(RM) *.elf.ltrans0.s
	-rmdir $(BUILD_PATH)
clean_bin:
	@echo ----------------------------------------------------------
	@echo Cleaning binaries
	-$(RM) $(OUTPUT_PATH)/*.*
	-rmdir $(OUTPUT_PATH)

init:
	@echo ----------------------------------------------------------
	@echo Initialising submodules
	git submodule update --init

.phony: print_info size clean_bin $(BUILD_PATH) $(OUTPUT_PATH)
