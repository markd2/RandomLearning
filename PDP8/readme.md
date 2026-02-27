# PDP-8


## PiDP-8

### connecting from mac serial (not wifi)

```
% ls /dev/tty.usb*
(e.g.) /dev/tty.usbmodem00011

% screen /dev/tty.usbmodem00011
```

Then linux-log in, then run `pidp8i', and get the '.' prompt for OS/8

`^Ad` to detach.

return to seesion with pidp8i at prompt

to stop sim

`^equit`

to restart service

`sudo systemctl restart pidp8i`


# Study

# OS 8

OS 8 Books from BitSavers: https://bitsavers.org/pdf/dec/pdp8/os8/

### Basics and Overview

Start here to understand what OS-8 is and how it’s structured.

* OS8_Handbook_Apr1974.pdf
* DEC-S8-OSRNA-B-D_os8v3DrelN.pdf

### User and System

Once you understand the big picture, read the manuals you’ll use most.

* AA-H607A-TA_OS8_V3D_sysMan.pdf
* DEC-S8-OSSMB-A-D_OS8_v3ssup.pdf
* AA-H606A-TA_os8SysgenNotes.pdf

### Language, development, and tools

* AA-H609A-TA_OS8_Language_Reference_Manual_Mar79.pdf
* AA-D319A-TA_os8DevExt.pdf
* AA-H608A-TA_os8teco_mar79.pdf

### Misc references

* AA-H610A-TA_os8errMsg_mar79.pdf
* OS8_V3_Memos_1973.pdf
* DEC-S8-OSHBA-A_DN4_OS8_Handbook_Update_Sep77.pdf




