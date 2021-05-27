CHIPNAME_U=$(shell echo $(CHIPNAME)|tr 'a-z' 'A-Z')
CHIPNAME_L=$(shell echo $(CHIPNAME)|tr 'A-Z' 'a-z')

# Only 8KB reserved for bootloader
FLASH_SIZE=$$((8*1024))

# Preprocessor directive uses the A suffix
CHIP_DEF=__$(CHIPNAME_U)A__

ifneq (,$(findstring 18,$(CHIPNAME_U)))
  LD_SCRIPT=bootloader_samd21x18.ld
  RAM_SIZE=$$(((32-1)*1024))
endif

ifneq (,$(findstring 17,$(CHIPNAME_U)))
  LD_SCRIPT=bootloader_samd21x17.ld
  RAM_SIZE=$$(((16-1)*1024))
endif
ifneq (,$(findstring 16,$(CHIPNAME_U)))
  LD_SCRIPT=bootloader_samd21x16.ld
  RAM_SIZE=$$(((8-1)*1024))
endif
ifneq (,$(findstring 15,$(CHIPNAME_U)))
  LD_SCRIPT=bootloader_samd21x15.ld
  RAM_SIZE=$$(((4-1)*1024))
endif
