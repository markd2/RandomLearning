# PDP-8

Stuff to read

* https://homepage.cs.uiowa.edu/~jones/pdp8/UI-8/guide.shtml
* https://bigdanzblog.wordpress.com/2014/05/23/editing-files-on-a-pdp-8-using-os8-edit/



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


## Stuff

### Running Adventure

(courtesy of https://raymii.org/s/articles/Running_ADVENT-on-the-PDP-8-with-SIMH.html)


```
.R FRTS
*ADVENT
<esc>
```

(fortran Run Time System)

ghostty --command "./vt2400 /dev/tty.usbmodem00011"

ghostty --device /dev/tty.usbmodem00011 --baud 2400



socat -d -d PTY,raw,echo=0,link=/tmp/pidp8-pty \
      EXEC:"./vt2400 /dev/tty.usbmodem00011",raw,echo=0



# PTY for Ghostty to connect
mkfifo /tmp/pidp8-in
mkfifo /tmp/pidp8-out

# PiDP-8 → throttled PTY
cat /dev/tty.usbmodem00011 | pv -q -L 240 > /tmp/pidp8-out &
# Keyboard → PiDP-8
cat /tmp/pidp8-in > /dev/tty.usbmodem00011 &


^E
reset
boot rk
