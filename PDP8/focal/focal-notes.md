# FOCAL

* https://homepage.cs.uiowa.edu/~dwjones/pdp8/focal/
* https://homepage.cs.uiowa.edu/~dwjones/pdp8/focal/UWFocal.pdf

### (focal-booklet.pdf)

https://homepage.divms.uiowa.edu/~jones/pdp8/focal/focal69.html

Has a lot of typos in it, preserved from the original.

```
booklet:
01.10 FOR X=0,10,100;TYPE "X",X," ",X^2",X^2," ","SQRT",FSQT(X);

correct code:
01.10 FOR X=0,10,100;TYPE "X",X,"   ","X^2",X^2,"    ","SQRT",FSQT(X),!
```

"a new conversational language developed by DEC for
its PDP-9 family of smol computers"

THE COMPUTER IS STUPID

line numbers from 1.01 through 31.99
  - otherwise line is immediate, like early pc basics
  - "line 1.50" can be called "line 1.5"

! in a TYPE = CRLF
# in a TYPE = CR without LF
  - doesn't really work with modern terminals


### Commands

use ^H for backspacing
  - although lines that i backspaced in don't run.

set throttle 333K

.R PFOCAL  (then answer Y)

* L C HANGMN   ; LIBRARY CALL
* GO

* ERASE ALL
* ERASE _line number_
* LOGICAL EXIT - L E  - quit
* WRITE ALL - list
  - WRITE works too
  - nice, puts a newline between major number groups
  - WRITE 1.0 - prints out 1.0 paragraph
  - WRITE 1.1 - prints out line 1.1


* LIBRARY SAVE DSK:FILE.EX

(this list is from UW/Focal, so may have too many things)

ASK - like INPUT
  - not ascii - "A" is value of 1, "W" is 23
    - as is "1" value of 1.
    - (hoooo boy...)
  - Space also commits, not just CR, as does ALT mode, and comma
  - docs say ":" gets printed, but not for me
  - ALT mode used when user doesn't want to change the value of
    an identifier
COMMENT - ignores remainder of the line
CONTINUE - "C" - same as comment / dummy line
DO - like GOSUB
  - DO 2 - starts at the top of the second group, continues working
    in sequence until hit RETURN or hit the end of the group.
  - DO 2.1 - runs line 2.1 only, then returns
  - just DO runs the whole program
  - IF/GOTO when inside a group being DO'd, (duuuuude), 
    - if inside the grop, will return as normal when it hits the end
    - if goes outside the group, that line is executed, then control
      returns to the DO, bypassing the rest of the group
  - can use variables.  `SET X = 5.24; DO X`.  That's pretty spif
    - helps avoid complex / memory nomming IF statements
ERASE
  - ERASE 2.0 - delete the 2.0 group
  - ERASE 7.11 - delete the line
  - ERASE ALL - nuke user's input
FOR var = initial_value, change_by, final_value; {command}
  - command can be a DO with all its behaviors
  - change by can be omitted and a +1 will be used instead
  - math is done in the floating point realm
GO - start program with lowest number
  - GO ?  - does a program trace (!)
GOTO - GOTO line number. doesn't care about groups.  Can use variables
IF (variable) lt-branch, eq-branch, gt-branch
  - can use a reduced form by omitting eq/gt-branch
    - e.g. IF (blah) 2.3
    - can't use DO entire group behavior
    - can do an else by using a semicolon
    - IF (0) 2.3; TYPE "SNORGLE"
MODIFY
  - interactive editing
QUIT - terminate program (but not focal)
RETURN - return from a DO #.0 block.  Falling off a group (Before going
to another major number) implicitly does a return if you did a DO groupnum
  - also "allows escape" from a LIBRARY GOSUB

SET - like LET.  Like Applesoft, only the first two chars are significant.
  (alpha, then alphanum) - so max of 936 variables
  - literally updates the symbol table
?TRACE? - wrap stuff to print out in ?'s
  - 1.4 type ?B+A/C?,! - prints out the expression and the value
TYPE - like print
  - TYPE $ - get a list of identifers in the symbol table
  - can omit the last " (!)
  - In code, can do T (!) (") and (#) to print out protected values
    POUND   2310.00
    BANG    0.0000
    QUOTE    0.0000
    - # I set to 1 by the initial dialog if all optional features of ps/8 focal
      are deleted, and 2310 if standard features are retaained
    - no idea what bang and quote are for
  - TYPE :12,"X" - output on position 12 of line. can have multiple
  - TYPE %10.09 - up to 10 digits to be printed, 9 may be decimals
    - alone on line
  - TYPE %
    - formats output in powers-of-ten

WRITE
  - without argument to list out all indirect staments
  - can do WRITE 2.0 (all group 2 lines)
  - WRITE 2.1 - that line

## LIBERRY COMMANDS

`LIBRARY <COMMAND>[DEVICE:]<PROGRAM NAME> [LINE NUMBER]`

PS/8 device names
  - SYS: system device (DSK: in disk system, DTA0: in dectape system)
  - DSK: disk in disk systems. also dectape #1 in dectape systems
    DSK: is assumed if a device is not specified
  - DTA0: - DTA7: - DECTAPE drives
  - LTA0: - LTA7: - LINCTAPE drives
  - MTA0: - MTA7: - MAGTAPE drives
  - PTR: high speed (paper tape) reader
  - PTP: high speed (paper tape) punch
  - LPT: line printer
  - TTY: terminal (may be used with other devices through 'ECHO')

LIBRARY CALL
  - load program for use
  - LIBRARY CALL OOPACK - loads OOPACK.FC for use
  - L C DTA3:PRGRAM - load from dectape #3
  - L C TEST1 - loads TEST1.FC fro mDSK:
  - assumes .FC extension
LIBRARY DELETE
  - "unsaves"
  - LIBRARY DELETE TTEST - "unsaves" TTEST.FC
  - closes open output files
  - assumes .FC extension
LIBRARY GOSUB
  - LIBRARY GOSUB TEXT 13.7 - line 13.7 of 'TEXT.FC' becomes a subrouting
    which returns to the command following GOSUB.
    - if run from a ne
  - L G SUMSQR - treat entire SUMSQR.FC as a subroutone
  - L G CALC 7 - group 7 of CALC.FC like a subroutine
  - closes open output files if given by an unsaved version of the program
LIBRARY LIST
  - list local files saved on disk
  - file length in blocks is also printed
  - LIBRARY LIST DEV:FNAME - list the single file
  - standard extensions are FC - program, FD - data files
LIBRARY RUN
  - loads file and beings execution
  - LIBRARY RUN DTA2:ZONE - runs zonk.FC from dectape #2
  - if you have 'run', you must save it prior to execution
LIBRARY SAVE
  - saves indirect program
  - LIBRARY SAVE PROG - save as PROG.FC
  - old file is deleted when new is saved
LIBRARY EXIT
  - leave focal, return to OS monitor


LIST ALL
LIST ONLY
LOGICAL BRANCH
LOGICAL EXIT

## File commands

  - "the experienced programmer may read and write PS/8 compatible data files
    with many devices"
  - FD for dta files.  saved in "standard ps/8 ascii format" and are
    EDIT and TECO-8 compatible
  - TTY: is normal input and output device, can use OPEN INPUT to select
    another device for input
  - open output does same for output.
    - close one output file before openign another
  - tack ",ECHO" to the input command to echo the input data on the
    output device.  added to output command, cases the output to be
    echoed on the terminal
  - reading and writing can be resumed with previously opened non-tty:
    devices through "open restore input/output" commands
  - when writing focal data files, need to include a space, comma, CR or
    any delimiter preceding any minus signs.
    - otherwise the number will appear positive when 'asked'
    - a preceding space will automatically be TYPEd if the initial dialog
      receives an answer of YES or '4,5'
Open output files are closed with LIBRARY SAVE or DELETE, or if LIBRARY
GOSUB is given by a non-saved program

OPEN INPUT
  - switch input to the file name
  - OPEN INPUT BLEEP
  - O I DTA4:RED - open file on dectape drive 4
  - O I TABLE,ECHO - echo on output device while reading TABLE.FD from the dsk:
  - OPEN INPUT TTY:,ECHO - restore terminal to normal function
  - O I TTY:,E - abbrev
  - ^Z is the EOF character.
  - attempts to read past it will output a '?' and switch input to the terminal
OPEN OUTPUT
  - OPEN OUTPUT DK - opens DK.FD to be written on the dsk:
  - O O DOPE,ECHO - echos on TTY: while writing DOPE.FD on DSK:
  - be sure to OUTPUT CLOSE when done
OPEN RESTORE INPUT
  - resumes asking for data from a previously opened input file after using
    TTY: input wiht open input tty:,Echo
  - O R I - abbrev
  - O R I,E - abbrev

OPEN RESTORE OUTPUT
  - resumes 'typing' on a previously opened output device after using TTY:
OUTPUT CLOSE
  - ends file writing and saves output file if device is file structured
    (disk/magtape)


## operators

^ exponentiation
* multiplaction
/ division
+ addition
- subtraction
() [] <> - expression delimiters. arbitrary usage


### Special characters

! CRLF
# CR
: Tabulate
% format control
$ symbol table
" quote marks
? trace
E power of 10
, comma
; semicolon
~ delete input
  rubout
  lf
  altmode
  escape
  return
  space
  ^C
  ^F -- break character
  ^G
  ^L
  ^Z
  ^P - INTERRUPT CHARACTER (FINALLY!)

### FILE COMMANDS

OPEN INPUT
  - change input device.  e.g. to high speed paper tape reader with
  - `OPEN INPUT PTR:`, and then back to terminal with `OPEN INPUT TTY:,ECHO`
OPEN OUTPUT
OPEN RESTORE INPUT
OPEN RESTORE OUTPUT
OPEN RESTART READ
OUTPUT ABORT
OUTPUT BUFFER
OUTPUT CLOSE
OUTPUT DATE
ONLY LIST


#### Functions

* names are FXXX
* three basic types of functions
  - integer part, sign part, abs
  - extended arthmetic functions (loaded at the cost of 800 locations)
    from the PDP-8 three-word floating point package
  - input/output are thrid type, includes nonstatistical random number
    generator.

FABS - absolute value
FADC - analog to digital input function.  `SET X=FADC();`
FATN - arctangent (radians)
FCOS - cosine
FDIS - display
FEXP - e to the power of arg
FITR - integer part, "up to 2046"
FLOG - natural logarithm
FRAN - random nubmer generator
FSGN - sign part (0/+1/-1)
FSIN - sine
FSQT - square root
FIN - character input
  - read one character and it returns the ASCII value
FOUT - character ouput
  - write one character ASCII value




## Errors
?00.00   MANUAL START FROM CONSOLE
?01.00   BREAK FROM KEYBOARD VIA 'CTRL/P'
?01.40   BAD LINE NUMBER
?01.91   GROUP NUMBER LARGER THAN 31
?01.;3   ZERO IS ILLEGAL LINE NUMBER
?02.32   'DO' REFERENCED NON-EXISTENT GROUP
?02.52   'DO' REFERENCED NON-EXISTENT LINE
?03.05   NON-EXISTENT LINE AFTER 'GOTO' OR 'IF'
?03.28   ILLEGAL COMMAND
?04.39   BAD VARIABLE IN 'FOR' OR 'SET' COMMAND
?04.52   EXCESS RIGHT TERMINATORS
?04.60   ILLEGAL TERMINATOR IN 'FOR' OR 'SET' COMMAND
?04.:3   MISSING ARGUMENT IN DISPLAY FUNCTION
?05.48   BAD ARGUMENT IN 'MODIFY' COMMAND
?06.06   ILLEGAL USE OF A FUNCTION OR NUMBER
?06.54   TOO MANY VARIABLES
?07.38   NO OPERATOR BEFORE PARENTHESIS
?07.:9   FUNCTION ARGUMENT MISSING
?07.;6   ILLEGAL FUNCTION OR DOUBLE OPERATORS
?08.47   ENCLOSURES DO NOT MATCH
?09.11   BAD ARGUMENT IN 'ERASE' COMMAND
?10.:5   STORAGE FILLED BY TEXT
?11.35   INPUT BUFFER OVERFLOW
?15.28   BAD RESTORE COMMAND
?15.;1   ATTEMPT TO WRITE PAST END-OF-FILE
?20.34   LOGARITHM OF ZERO REQUESTED
?22.23   NO OUTPUT FILE TO RESTORE
?22.51   BAD FILES 'OPEN' COMMAND
?23.05   DATA FILE NOT FOUND
?23.15   NO INPUT FILE TO RESTORE
?23.36   TOO MANY DIGITS IN NUMBER
?23.39   PUSHDOWN OVERFLOW; PROGRAM TOO LONG
?24.60   TWO PERIODS IN FILE NAME OR NO NAME
?25.37   BAD DEVICE OR 2 PAGE HANDLER
?26.18   BAD LIBRARY COMMAND
?26.58   NO PROGRAM NAMED BY 'SAVE' COMMAND
?26.99   EXPONENT TOO LARGE OR NEGATIVE
?27.10   PROGRAM NOT FOUND
?27.14   'LIBRARY CALL' FROM NON-DIRECTORY DEVICE
?28.06   'LIBRARY LIST' OF NON-DIRECTORY DEVICE
?28.73   DIVISION BY ZERO
?29.53   FILE ALREADY DELETED
?29.68   DEVICE ERROR:  WRITE LOCK OR PARITY
?29.91   CANNOT OPEN OUTPUT FILE
?30.05   IMAGINARY SQUARE ROOTS REQUIRED
?31.<7   UNAVAILABLE COMMAND OR FUNCTION
?        ATTEMPT TO READ PAST END-OF-FILE (INPUT IS
         SWITCHED TO TERMINAL AND PROGRAM CONTINUES)


## Random

do we need high-bit set for input?

no real string processing - purely numerical

F71 has "extended library features with device-independent chaining and
subroutine calls between programs"

file reading and writing commands, 10-digit precision, and/or standard
trig functions can be deleted by the initial dialog to allow up to
222 variables with 5500 character programs.  With all features, it's
98 variables and 3500 charcter programs.

"TABULATION" listed as a feature. is that "#" (no LF on CR), or something
more interesting.  F69 seems to have that "#" feature, so probably not that

FDIS for Dec 34D display, versions available with display and joystick functions
for TEktronix T-4002

PS/8 datafiles compatible with Edit and TECO-8.
Program files saved as core images

# FC from foc71-omsi.tu56


