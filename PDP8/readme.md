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

pidp8i stop


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


https://hackaday.com/2017/08/10/getting-started-with-blinking-lights-on-old-iron/
  - https://www.youtube.com/watch?v=yUZrn7qTGcs

https://www.youtube.com/watch?v=S2r_GujSc6w


Running adventure

```
.R FRTS
*ADVENT
<esc>
```


Running BASIC

EX TICTAC.BA


BASIC
OLD
TICTAC


--------------------------------------------------
# a demo(e)

https://www.youtube.com/watch?v=oMRDAD1JNWo

* Stop
* (put program in at address 10 (octal))
* so set switches to 10, and then load address - lights on top line match the switches
* first instruction.  put in HLT opcode is 7402, and DEPosit
  - notice "memory buffer" shows 7402
  - notice "address" shows the address we entered
  - notice the ProgramCounter lights have added 1 binary)
  - (so you could continue to DEP more instructions)
* now run it by putting in 10 - see the address / top line update
* press start
  - it ran and halted
  - notice PC ticked over to show _next_ instruction it would run
  - notice OPR light is on - HLT is in the operation category

increment the accumulator. - six instruction, incr the accum five times.

* 0010 and load address
* 7001 is the increment accumulator so put that into the switches
* press DEP five times. (so run it five times
* then 7402 to halt after the add and DEPosit that
* let's examine memory
* 0010 and load address.
* see what's at that address with EXAMine
  - shows the memory buffer, which is 7001
  - increments the program counter
* keep EXAM and they're the same, and eventually will get the 7102
* LOAD ADDR with 0010 still on switches
* then can press start - what do you expect to happen (accum goes to
  five very quickly)
* we can do more interesting things.  Go back to 0010 with LOAD ADDR.
* toggle the SINGLE INSTruction toggle
* now CONTinue will just execute one instruction
  - notice the program counter is one ahead - might be a pi thing, or
    maybe not - like it's expected to be one ahead, but it's two ahead,
    so it's probably preftecthed the _next_ instruction

so now for a loop
* now for a two-instruction program.  increment accumulator, and jump
  to the beginning
* go back to 0100 and LOAD ADDR.  Turn off SING INST switch
* 7001 for increment accumulator, DEPosit
* 5 + address to jump to - so 5010
  - (video showed the instruction jmp lamp lights up. mine did not)
* now do the examine again
  - 0100 and LOAD ADDr
  - EXAM - see 7001
  - EXAM - see 5010 (I am not seeing the instruction lamps follow along)
  - load address and press start. What do you expect to happen?
    - the accumulator totally fills up, because it's adding and overflowing
      so fast
    - notice the opr and jmp lamps are flashing
    - video has fetch and execute flashing, but just fetch i sdoing that for me
* STOP / CONTINUE and see the accumulator have different values
* put on SING INST
* CONT CONT CONT
  - see the light bounce between OPR and JMP (increment jump)
  - see the accumulator increment by one

* say wanted to slow it down?
* say add a delay loop - one more instruction, ISZ - increment
  and skip if zero
  - increments a location, if zero, it'll skip the next instruction
  - essentially doing it 4096 times
* turn off SING INST
* 0100 and LOAD ADDr
* 7001 and DEPosit - first instruction, increment acunulator
* 2___ - increment and skip if zero
   - 2 plus address of what we want to increment.
   - address 3-4 is popular with demos, so do that
   - 2034 DEP
* next instruction is the jmp for the delay loop, that'll
  get skipped if the increment wraps around to zero
* we'll jump (5___) to the increment and set, which happens
  to be at the address 11.  so
  - 5011 DEP
  - that's the inner loop
* jump back to the beginning
  - 5010 DEP
* then go to 0010 load addrr, and then exam the program
* then start, can single 

0010: 7001   IAC       // accumulator++
0011: 2034   ISZ 0034  // memory[0034]++, skip next if zero
0012: 5011   JMP 0011
0013: 5010   JMP 0010


### RUNNING FOCAL

use `UWF16K` to run the UWFOCAL

```
.R UWF16K
*ASK "input number",X
input number23
*type X,!"!!"
 2.300000000E+01
!!*
*
```


### Running Fortran

make a .FT file, say HERRO.FT

```
.R F4
*HERRO,HERRO,HERRO<HERRO

.EXE HERRO.RL
```

that made a .RL

shortcut to compile, link, load, save, and execute is

```
.R F4
* PROG/G<esc>
```

THis made a .LD.

don't understand what the difference is and why it picked one over the other.


### Running PAL assembly

.PA file

```
PAL PROG
EXE PROG.BN
```

Supposedly we can do `LOAD/G PROG` to run it, but I get "GPROG OPTION UNKNOWN"

