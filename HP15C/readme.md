# HP-15C

Great calculator.  I snagged a Collector's Edition because it's a great
calculator, and now with a bit more memory and faster processing.  Same
great feel of the keyboard


## Easy Course

From the book "An Easy Course in Programming the HP-11C and HP-15C".
I grok the basic usage (from basically using it since high school),
but never delved into the programming aspect outside of cheating in
Physics class by verifying my by-hand answers by a very simple program
(no loops, no branches. I was a pretty terrible programmer at that age)

### Program Memory

The stock HP-15C has 67 registers of memory of 7 bytes each, the collector's edition 
has 99 (0...98).

The stock has 448 bytes of program memory (one or two bytes per instruction).
The collector's edition has 672.  Each register can hold seven lines of 
program.

There is a movable boundary that is the top of data memory, which controls
the number of (10-digit) data registers

```
65
64
63
...
22
21
20
.9
.8
.7
.6
.5   ^ other things, like programs, matrices, imaginary stack, etc
---- movable boundary
.4   v the top of data memory
.3
.2
p...
4
3
2
1
0
```

### Run vs Program mode

The machine starts up in Run mode - do calculations.  Can put it
into Run mode with `g P/R` (Program/Run).  The screen changes to
`000-` (the line number) and the `prgm` annunciator annunciates.

Clear the program memory with `f (clear) PRGM`.  the text also 
mentions `f MATRIX 0  g CF 8`.  With a promise that later one
we'll learn what that does.

Set the data register boundary (say to 65) via `65 f DIM (i)`.  This
moves the boundary to the top of the given _register_. Though it won't
let you clobber information currently there.  That's why we clearned it
it first.

By setting to the top `f 98 DIM (i)`, then going into `g P/R` mode, and
typing a command (say SIN), get an Error 4. - presumably the PRGM>MEM case.

Reminder storing in registers - put the value into X, then STO and 0...9 or .0... .9 (so a single, or in the case of .9, double, keystroke)  But storing into
say register 65 is different, and will be covered on page 144 (we're on 78)

Get a description of the status of memory with `g MEM`.  Hold down
the MEM Key to keep the thing visible.  It'll be a display like `19 78 0-0`.
First number is the memory boundary.  Second number is number of the rest
of the memory that are empty.  The last two are info about how much of
the above-barrier memory is being used to store program lines.

From the friendly manual, `dd uu pp-b` where
* dd: number of the highest-numbered register in the data sotrage pool,
  meaning the total number of data registers is dd + 2 because of R0 and R1
* uu: number of _uncommitted_ registers in the common pool
* pp: number of registers containing program intsructions
* b: the number of bytes left before uu is decremented (to supply seven more
  bytes of program memroy) and pp is incremented

Can also recall the data register boundary is via `RCL DIM (i)` (no need for
the f kye for getting to DIM and (i))

A simple "convert F to C" is done via

```
g P/R          go into program mode
32 - 5 x 9 ÷   operate on contents of X register
g P/R          exit program mode
```

When programming, you get weird numbers (keycodes) that come up. Will be
described later (page 91, currently on page 83)

Move the program counter to the beginning with `g RTN`

Run the program by putting in a value in X, and doing `R/S` without the `g`

`R/S` enables stack lift, so you don't need to terminate entry of a number
prior to running a program.

When pressing `R/S`, it starts at hte current program counter

When it hits the end of a program, it jumps back to line 000 and stops.
(which is why we didn't need an explicit return, I guess)

`SST` moves pointer ahead one line, `BST` backwards.  (hold down to see
the address and instruction to run)

To move to an absolute line number, do `GTO CHS nnn` where nnn is a three 
digit number

### Keycodes

Most keycodes are two digit which indicate the row (from top down) and
column (fromt left right), column 10 is 0.  So CHS is 16 - row 1, column 6.

Numbers are described by one digit


### Decisioning and Branching

"naked program" = one that runs from top to bottom, no frills, made up mainly
of arithmetic functions.

Labels used in programs as markers, like the top of a program, or important
landing points for jumping within a progam. Can tell the machine to move its
program pointer to a label with direct (manual) keystrokes, or with
jumping instructions.

The labels A->E, 0->9 plus .0->.9.  This is why GTO CHS nnn has three digits.
If it was 1 or 2, it would look like a label junk.

A,B,C,D,E can be called (run a program with them) from the keyboard.

doing `f LBL A` (or other labels) inserts the label, and pushes down and
renumbers code after that _(pretty cool)_   Can then run that program
by doing `f A`

GTO and GSB are used for branching to a LBL in a program.  Use RTN to return.
If there's no waiting gosub, a RTN means "end execution"

`f PSE` to pause execution

using three gsb statements, count in the dipslay from one to 3

f LBL C
0  ; zero out X
gsb 2
gsb 2
gsb 2
g RTN

f LBL 2
1
+
f PSE
g RTN

