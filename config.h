/*
 * Board-specific USB settings
 */
#ifndef _BOARD_CONFIG_H_
#define _BOARD_CONFIG_H_

/*
 * USB device definitions
 */
#define STRING_MANUFACTURER "Arduino LLC"
#define STRING_PRODUCT "Arduino Zero"
// Since this is written to a fixed address it must be less than 16 characters
// Leave as "XXXXXXXXXXXXXXX" for flash-time serial injection
#define STRING_SERIAL  "XXXXXXXXXXXXXXX"
#define USB_VID_HIGH   0x23
#define USB_VID_LOW    0x41
#define USB_PID_HIGH   0x00
#define USB_PID_LOW    0x4D

#endif // _BOARD_CONFIG_H_
