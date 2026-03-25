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


```
0200: 4C 06 02            JMP START
0203: 42 0E 0B      TABLE $42, $0E, $0B
0206: A2 00         START LDX #00
0208: 8D 03 02      LOOP  LDA TABLE,X
020B: 95 F9               STA F9,X
020D: E8                  INX
020E: E0 03               CPX #03
0210: D0 F6               BNE LOOP
0212: 20 1F 1F            JSR SCANDS
0215: 4C 06 02            JMP LOOP
```

(the 8D for LDA should be a BD)

KIM SUBROUTINES

```
CALL         ADDRESS   ARG           RESULT
JSR AK	     1EFE      --            A
    CHECK FOR KEY DEPRESSED
    A = 0 (KEY DOWN), A != 0 (NO KEY DOWN)
    CLOBBERS X AND Y

JSR GETKEY   1F6A      --            A
    GET KEY FROM KEYBOARD
    A > 15 ILLEGAL
    OR NO KEY

JSR SCANS    1F1F      F9, FA, FB    --
    DISPLAY F9, FA, FB
    CLOBBERS A, X, Y

JSR GETCH    1E5A      --            A
    PUT CHARACTER FROM TTY IN A
    X PRESERVED
    Y = FF

JSR PRTBYT   1E3B      A             --
    PRINTS A AS 2 HEX CHARACTER
    A AND X PRESERVED
    Y = FF

JSR PRTPNT   1E1E      FB, FA        --
    PRINTS CONTENTS OF FA & FB ON TTY
    CLOBBERS A
    X PRESERVED
    Y = FF

JST OUTCH    1EA0      A             --
    PRINT ASCII CHAR IN A ON TTY
    X PRESERVED
    Y = FF
    A = FF

JSR OUTSP    1E9E      --            --
    PRINT A SPACE
    A = FF
    X PRESERVED
    Y = FF
```

Displaying custom LED patterns (from Kim-1 notes)

1. Store $7F into PADD ($1741)

2. Select a digit by storing into SBD ($1742) (these increase by 2)

- digit 1 : `$09`
- digit 1 : `$0B`
- digit 1 : `$0D`
- digit 1 : `$0F`
- digit 1 : `$11`
- digit 1 : `$13`

3. store lit patterns into SAD ($1740)

4. delay 1/2 ms and move to the next digit (farmer brown does a wrap-around inc loop of zero-page address $73)

