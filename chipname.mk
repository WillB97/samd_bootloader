ifeq ($(CHIPNAME), SAMD21J18)
  CHIP_DEF=__SAMD21J18A__
  LD_SCRIPT=bootloader_samd21x18.ld
endif
ifeq ($(CHIPNAME), SAMD21J17)
  CHIP_DEF=__SAMD21J17A__
  LD_SCRIPT=bootloader_samd21x17.ld
endif
ifeq ($(CHIPNAME), SAMD21J16)
  CHIP_DEF=__SAMD21J16A__
  LD_SCRIPT=bootloader_samd21x16.ld
endif
ifeq ($(CHIPNAME), SAMD21J15)
  CHIP_DEF=__SAMD21J15A__
  LD_SCRIPT=bootloader_samd21x15.ld
endif

ifeq ($(CHIPNAME), SAMD21G18)
  CHIP_DEF=__SAMD21G18A__
  LD_SCRIPT=bootloader_samd21x18.ld
endif
ifeq ($(CHIPNAME), SAMD21G17)
  CHIP_DEF=__SAMD21G17A__
  LD_SCRIPT=bootloader_samd21x17.ld
endif
ifeq ($(CHIPNAME), SAMD21G16)
  CHIP_DEF=__SAMD21G16A__
  LD_SCRIPT=bootloader_samd21x16.ld
endif
ifeq ($(CHIPNAME), SAMD21G15)
  CHIP_DEF=__SAMD21G15A__
  LD_SCRIPT=bootloader_samd21x15.ld
endif

ifeq ($(CHIPNAME), SAMD21E18)
  CHIP_DEF=__SAMD21E18A__
  LD_SCRIPT=bootloader_samd21x18.ld
endif
ifeq ($(CHIPNAME), SAMD21E17)
  CHIP_DEF=__SAMD21E17A__
  LD_SCRIPT=bootloader_samd21x17.ld
endif
ifeq ($(CHIPNAME), SAMD21E16)
  CHIP_DEF=__SAMD21E16A__
  LD_SCRIPT=bootloader_samd21x16.ld
endif
ifeq ($(CHIPNAME), SAMD21E15)
  CHIP_DEF=__SAMD21E15A__
  LD_SCRIPT=bootloader_samd21x15.ld
endif
