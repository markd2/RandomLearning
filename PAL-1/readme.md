# PAL-1

USing a PL2303-DB9 serial cable.  Needing a driver from "prolific" for it
(available in the mac app store)

which adds a driver extension

/dev/cu.PL2303G-USBtoUART10

screen /dev/cu.PL2303G-USBtoUART10 2400

Using SERIAL to connect

1200.8.N.1

Reset, then press return on the mac

Serial cable (with the PL303blah driver, and a A->C adapter)

to go to an address
1234<space>

to deposit memory and move on
12.

Do _not_ use just a dot to go through memory, that drops zeros
everywhere.  Need to see if there's another command to do that.

(uppercase letters)

show contents of next address <return>  (don't use dot for this)
show contents of prior address <LF/^J)

G - run at the current address
L/Q - load or save a program using paper tape punch format.

saving.  End address in 17f7 and 17f8 in little endian

so say saving from 0200...02FF
17F7space
FF.  low byte
02.  high byte
0200space
Q



10ms delay per char and 100ms per line recommended  0.010  .1
and text pacing None (vs echo)

about 6 seconds per line. one page as about 12 lines.  so a minute and a half
feels longer.

Use L to load
and no CR after the L




BITZ

0200..027E  save F as well for safety

How to step (christopher): 
* slide SST switch to ON
* load the start address
* each GO will execute the next instruction, and dump values into memory:
    - $EF $F0 : Program counter
    - $F1: Processor flags
    - $F2: Stack pointer
    - $F3: Accumulator
    - $F4: Y
    - $F5: X
