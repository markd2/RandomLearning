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

* L C HANGMN
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
DO - like GOSUB
  - DO 2 - starts at the top of the second group, continues working
    in sequence until hit RETURN or hit the end of the group.
  - DO 2.1 - runs line 2.1 only, then returns
  - just DO runs the whole program
  - IF/GOTO when inside a group being DO'd, (duuuuude), 
    - if inside the grop, will return as normal when it hits the end
    - if goes outside the group, that line is executed, then control
      returns to the DO, bypassing the rest of the group
ERASE
  - ERASE 2.0 - delete the 2.0 group
  - ERASE 7.11 - delete the line
  - ERASE ALL - nuke user's input
FOR var = initial_value, change_by, final_value; {command}
  - command can be a DO with all its behaviors
  - change by can be omitted and a +1 will be used instead
  - math is done in the floating point realm
GO - start program with lowest number
GOTO - GOTO line number. doesn't care about groups
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
to another major number) implicitly does a return

SET - like LET.  Like Applesoft, only the first two chars are significant.
  (alpha, then alphanum) - so max of 936 variables
  - literally updates the symbol table
?TRACE? - wrap stuff to print out in ?'s
  - 1.4 type ?B+A/C?,! - prints out the expression and the value
TYPE - like print
  - TYPE $ - get a list of identifers in the symbol table
  - can omit the last " (!)
USER
VIEW
WRITE
  - without argument to list out all indirect staments
  - can do WRITE 2.0 (all group 2 lines)
  - WRITE 2.1 - that line
XECUTE
ZERO
(and others)

## LIBERRY COMMANDS

LIBRARY CALL
LIBRARY DELETE
LIBRARY GOSUB
LIBRARY RUN
LIBRARY SAVE
LIBRARY NAME
LIBRARY LIST
LIST ALL
LIST ONLY
LOGICAL BRANCH
LOGICAL EXIT

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

### FILE COMMANDS

OPEN INPUT
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

FSQT - square root
FABS - absolute value
FSGN - sign part (0/+1/-1)
FITR - integer part, "up to 2046"
FRAN - random nubmer generator
FEXP - e to the power of arg
FLOG - natural logarithm
FATN - arctangent (radians)
FSIN - sine
FCOS - cosine




## Errors
?01.40 - illegal step or line number used (e.g. 1.00)
?01.91 - (not in my list!)
?02.32 - nonexistent group referenced by 'DO'
?03.05 - nonexistent line used after goto or if
?03.28 - illegal command (e.g. syntax error, etc)
?06.06 - illegal use of function or number
  - make sure you're not doing "SUM = SUM + 1", without a SET
?08.47 - parenthesis do not match


## Random

do we need high-bit set for input?

no real string processing - purely numerical


community college

# FC from foc71-omsi.tu56


