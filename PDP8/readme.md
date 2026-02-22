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

