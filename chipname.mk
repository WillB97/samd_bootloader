CHIPNAME_U=$(shell echo $(CHIPNAME)|tr 'a-z' 'A-Z')
CHIPNAME_L=$(shell echo $(CHIPNAME)|tr 'A-Z' 'a-z')

# Only 8KB reserved for bootloader
FLASH_SIZE=$$((8*1024))

ifeq ($(CHIPNAME_U), SAMD21J18)
  CHIP_DEF=__SAMD21J18A__
  LD_SCRIPT=bootloader_samd21x18.ld
  RAM_SIZE=$$(((32-1)*1024))
endif
ifeq ($(CHIPNAME_U), SAMD21J17)
  CHIP_DEF=__SAMD21J17A__
  LD_SCRIPT=bootloader_samd21x17.ld
  RAM_SIZE=$$(((16-1)*1024))
endif
ifeq ($(CHIPNAME_U), SAMD21J16)
  CHIP_DEF=__SAMD21J16A__
  LD_SCRIPT=bootloader_samd21x16.ld
  RAM_SIZE=$$(((8-1)*1024))
endif
ifeq ($(CHIPNAME_U), SAMD21J15)
  CHIP_DEF=__SAMD21J15A__
  LD_SCRIPT=bootloader_samd21x15.ld
  RAM_SIZE=$$(((4-1)*1024))
endif

ifeq ($(CHIPNAME_U), SAMD21G18)
  CHIP_DEF=__SAMD21G18A__
  LD_SCRIPT=bootloader_samd21x18.ld
  RAM_SIZE=$$(((32-1)*1024))
endif
ifeq ($(CHIPNAME_U), SAMD21G17)
  CHIP_DEF=__SAMD21G17A__
  LD_SCRIPT=bootloader_samd21x17.ld
  RAM_SIZE=$$(((16-1)*1024))
endif
ifeq ($(CHIPNAME_U), SAMD21G16)
  CHIP_DEF=__SAMD21G16A__
  LD_SCRIPT=bootloader_samd21x16.ld
  RAM_SIZE=$$(((8-1)*1024))
endif
ifeq ($(CHIPNAME_U), SAMD21G15)
  CHIP_DEF=__SAMD21G15A__
  LD_SCRIPT=bootloader_samd21x15.ld
  RAM_SIZE=$$(((4-1)*1024))
endif

ifeq ($(CHIPNAME_U), SAMD21E18)
  CHIP_DEF=__SAMD21E18A__
  LD_SCRIPT=bootloader_samd21x18.ld
  RAM_SIZE=$$(((32-1)*1024))
endif
ifeq ($(CHIPNAME_U), SAMD21E17)
  CHIP_DEF=__SAMD21E17A__
  LD_SCRIPT=bootloader_samd21x17.ld
  RAM_SIZE=$$(((16-1)*1024))
endif
ifeq ($(CHIPNAME_U), SAMD21E16)
  CHIP_DEF=__SAMD21E16A__
  LD_SCRIPT=bootloader_samd21x16.ld
  RAM_SIZE=$$(((8-1)*1024))
endif
ifeq ($(CHIPNAME_U), SAMD21E15)
  CHIP_DEF=__SAMD21E15A__
  LD_SCRIPT=bootloader_samd21x15.ld
  RAM_SIZE=$$(((4-1)*1024))
endif
