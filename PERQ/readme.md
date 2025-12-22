# PERQ

Instructions on running things: https://www.reddit.com/r/vintagecomputing/comments/1izwj4g/emulating_the_perq_with_perqemu/

Get from https://github.com/skeezicsb/PERQemu/releases

Lots o docs at http://www.bitsavers.org/pdf/perq/

* https://www.youtube.com/watch?v=kxYpfsJtEtc - SIGGRAPH PERQ demo
* https://www.youtube.com/watch?v=Fap-mXY80ls - Intran demo
* https://www.chilton-computing.org.uk/acd/sus/perq_history/overview.htm - PERQ history
* https://www.youtube.com/watch?v=iB9y7j4EYs4 - demo of PERQemu
* https://graydon2.dreamwidth.org/313862.html - more history
* lots o stuff - https://blisscast.wordpress.com/2024/08/20/three-rivers-perq-gui-wonderland-4/#foot2a
* FAQ - https://archive.decromancer.ca/vonhagen.org/perq-gen-faq.html
* newsgroup - alt.sys.perq

# Running macstyles:

```
brew install sdl2 sdl2_image
brew install --cask --no-quarantine wine-stable
cd $WHEREVER
wine PERQemu.exe
go
```

# Lobbing in and Running

- username: guest
- password: none

# Random commands

* `dir`
* `dir >*.run` - see all the available things to run
* `bye` - logout
* `configure memory 2048`
* `configure show`
* `configure enable rs232`
* `> settings assign rs232 device A RSX:`


# Programming

"if you want to compile a program immediately after editing it, you
need not specify its name since the Shell remembers the last file edited, compiled, linked, or run"

## Pascal

* INTEGER is 16 bits (signed), a.k.a. single precision whole number
* LONG is 32 bits (signed), a.k.a. double preecision whole number
* REAL is 32 bits, IEEE floating point format
* STRETCH: convert single precision whole number into double precision whole
* SHRINK: convert double precision whole number into single precision. Runtime error if the converted value is too large for its destination
* FLOAT / TRUNC / ROUND : convert real->integer or integer->real
* there is a CONVERT module for converting floating point number into double-precision whole number (and reverse)
* octal constants indicated by `#` preceding the number
* can use (compile-time) constant expressions in CONST section
* RECAST - see below
* WORDSIZE - see below
* type compatibility: defined by BSI/ISO standard, plus "any two strings, regardless of their maximum static lengths, are considered compatible"
* extended CASE statement - constant subranges as labels.  The "othewise" clause.  The subranges can't overlap.  If a value is used, but not handled by the case labels, and no otherwise, is a no-op in PERQ land. It's a fault in standard pascal
* EXIT is forced termination of procedures or functions - either the current one, or from any of its parents (!)  Takes the procedure/function name to exit as a parameter.  Functions that are force-exited and don't have a `BLAH := VALUE;` statement will result in undefined values.  If the specified routine is not on the call stack, "the PERQ crashes" (the entire machine?)
* SETs - supports the standard pascal construcvtus.  Space is allocated in a bit-wise fashion (at most 255 words, for maximum size of 4080 elements). If the basetype is a subrange of integer, it needs be be 0..4079.
* can compare RECORDs, so long as no portion of the record is packed.
* There are two "generic" types - pointers and files (see below)
* permits the parameter list of the implementation of forward-declared functions and procedures to be omitted.
* Functions can return any type, except FILE
* support passing procedures and functions as parameters (as described by
  the BSI/ISO Pascal Standard, 1979).  Need to put the full description of the
  procedure parameter in the routine header.  e.g. `procedure EnumerateAll (directory: String; Function for each one (filename: String): boolean; all: boolean);`.  If the procedure is forward declared or in an export section, the routine header cannot be repeated.
* Modules - see below
* Exceptions (!) - see below
* There are logical (bitwise) operators - LAND, LOR, LNOT, LXOR, SHIFT, ROTATE
* Standard file stuff, like REWRITE, RESET, READ(LN), WRITE(LN), CLOSE
* Also misc intrinsics peculiar to PERQ (see below)

#### RECAST

**Recast** Converts the type of an expression from one type to another where both types require the same amount of space.  Processed at compile time, so no runtime overhead.  `blah := RECAST(value, typename);`.  Example shows converting between an enumerated type and its raw value.  `I := 0; C := RECAST(I, color);` gives `red` because it's the first deal in the `color` enumeration.  "use sparingly and always scrutinze the results" - successful compilation does not imply the recast will work correctly.

These conversions produce expected results:

* longs, relas, and pointers to any other type
* arrays and records to either arrays or records
* sets of 0..n to any other type
* constants to long or real
* one word types (except sets) to one word types (except sets)

#### Strings

String facility providing variable length strings with max size limit for
each string.  Default max len of a STRING is 80 characters.  Can override
in the declaration

Assign via `:=` or `READ`.  Assignment can be dne so long as the dynamic
lenght of the source fits in the max length of the destination.

Can index into a string (**1** based). Going off the end of the dynamic
length is a runtime "invalid index" error.

Can be compared regardless of dynamic and max lengths. The full 8 bits of
ASCII used (bit 7 as "ascii parity bit")

0..255 is the dynamic length

LENGTH returns the length


### Generics

Two predefined 'generic' types - pointers and files.

#### Pointers

Generic pointers are for generalized pointer handling.  (feels more like type erasure than modern generics) 

Variables of type
POINTER can be used in the same manner as any other pointer variable, subject to:

* cannot dereference them (because no type associated with them)
* cannot be used as an argument to NEW or DISPOSE
* any pointer type can be passed to a generic pointer parameter.  To use it, RECAST it to some usable pointer type


#### Files

Purpose is to provide a facility for passing various types of files to a single
procedure or function.

May only appear as a routine VAR parameter, type is FILE.  Can be used in two
ways:

* passed as a parameter to another generic file paramter
* as an argument to the LOADADR intrinsic

### Modules

encapsulates procedures, functions, data and types; and supporting separate
compilation.  Unexported identifiers are private to the module.

exporting makes constants, tpes, variables, procedures, and functions availabel to other modules.  Importing lets you use the exports of other modules.

modules with only type and constant declarations cause no runtime overhead,
making them ideal for common declarations.  They shouldn't be compiled (yay
errors), but can be successfully imported.

#### Exports

if a program or module is to contain any exports, the EXPORTS declaration section must immediately follow the program or module heading.

the EXPORTS declaration section has those items to be exported.  Procedure and function bodies are not given in the exports section - just forward references.  The inclusion of FORWARD is omitted.

EXPORTS is termianted by PRIVATE, which indicates begining of local definitions.

For a program segment, if it has no exports, then the inclusion of private is assumed.


#### Imports

IMPORTS specifies modules which are to be imported.  Includes module name and the source file name.  (if the module is composed of several INCLUDE files, only those files from the file containign the progrma or module heading through the file which contains the word PRIVATE, must be available)

`<import decl part> ::= IMPORTS <module name> FROM <file name>;`


### Exceptions

Three steps to using an exception:

* exception must be declared
* a handler must be defined
* the exception must be raised

Declaration: EXCEPTION - name, and optional list of parameters

```pascal
EXCEPTION DivisionByZero(Numerator: integer);
```

can be declared anywhere in the declaration portion of a program or module.

Making a handler:

```pascal
HANDLER DivisionByZero(Top: integer);
<block>
```

(essentially, they look like procedures, and can be intermixed with
procedure definitions)

Multiple handlers can exist for the same exception, as long as there is only one per name scope.

Raise by using RAISE:

```pascal
RAISE DivisionByZero(N);
```
When the raise happens, the stack is cralwed until a subprogram containing
a handler (of the same name) is found.  Procedures can have their own handlers.

```pascal

program Blah;
exception Ex;

handler Ex; { global handler
begin
    { do stuffs }
end;

procedure proc;
    handler Ex;
    begin
      { do stuffs }
    end;
begin
    raise Ex;  {hits our nearby handler}
end;
```

If a handler is active, and another exception is raised, then the
search continues from there for a non-active handler.

Recursive procedures has its own eligible handler per activation.

When a handler terminates execution resumes at the place following the
RAISE statement. The handler can dictate otherwise by using EXIT
and GOTO

Generally used for serious errors.  


If an exception bubbles out the top, the system catches it and invokes
the debugger.  Can do `EXCEPTION ALL(ES, ER, PStart, PEnd: integer);`

* ES is system segment number of the exception
* ER is the routine number of the exception
* PStart is the stack offset of the first word of the exception's original
  parameters
* PEnd is the stack offset of the word following the original parameters

"extreme caution should be used when defining an ALL handler" - it'll grab system exceptions too.  "for systems hackers only"

There are some OS default handlers - look at "Program System" and "Module Exception" in the Operating System Manual.


### Dynamic Space (de)allocation

Supports NEW and DISPOSE (from standard pascal), and some upwardly
compatible extensions.

Two features of PERQ's memory architecture that require extensions:

* some things require particular alignment of memory buffers, like for I/O operations
* supports multiple data segments from which dynamic allocation may be performed. - can groupo data together to be accessed together, imprivng PERQ's performance due to improved swapping.

Data segments are multiples of 256 words in size and are always aligned on 256 word boundaries.  _(see doc on the memory manager)_\

#### NEW

`NEW(Ptr(Tag1,...TagN))`

memory is allocated with arbitrary alignment from the default dat segment.

Also an extension:

`NEW(Segment, Algnment, ptr(Tag1, ...TagN)`

* Segment is the segment number - zero for the current default data segment. 
* alignment is the desired alignment - any power of 2, 2 to 256. Do not use zero.

If  the callocation fails, NIL is returned. If memory is exhausted, FULLMEMORY
exception may be raised.  The program will abort uniless there's a handler for
it.

#### DISPOSE

DISPOSE identical to standard pascal.  Don't need to give segment and alignment,
just pointer and tag fields.

### Misc Intrinsics


STARTIO(unitNumber) - a special QCode to initiate I/O operations to raw devices. 

#### RasterOp

RasterOp - a special QCode used to manipulate blocks of memory of arbitrary sizes.  It modifies a rectangular area (the destination) of arbitrary size (to the bit).  The source and destination are combined using specific raster op functions.

Can work on memory other than used for the screen bitmap.  RasterOp has paramters that specify the areas of memory to be used for source and destination - pointer to the start of the memory block, and the width in words.

within those regsions, the postiosn of the source and destination rectangles
are given as offset from the pointer.  (0,0) would be at the upper-left
and for the screen, (767, 1023) is the lower right.

The `Screen` module exports useful parameters.

```pascal
RasterOp(Function,
         Width,    { in bits
         Height,   { in scan lines
         Destination-X-position,  { bit offset from the left sie of dest rect
         Destination-Y-position,  
         Destination-Area-Line-Length, { number of words that comprise a line - multiple of 4 from 4..48
         Destination-Memory-Pointer,  { 32-bit virtual address of top-left corner of destination region. quadword aligned
         Source-X-position,
         Source-Y-position,
         Source-Area-Line-Length,
         Source-Memory-Pointer)
```

Function (symbols exported by Raster.pas):

```
0    RRpl     Dst gets Src (replace)
1    RNot     Dst gets NOT Src
2    RAnd     Dst gets Dst AND Src
3    RAndNot  Dst gets Dst AND NOT Src
4    ROr      Dst gets Dst OR Src
5    ROrNot   Dst gets Dst OR NOT SRC
6    RXor     Dst gets Dst XOR Src
7    RXNor    Dst gets XNOR Src
```

#### WordSize

returns the number of words of storage for any item which has a size
associated with it.  Generates compile-time constants, so can be used
in constant expressions.

#### MakePtr

permists the user to create a pointer to a data type given a system
segment number and offset.  (intended for those who are fimiliar with the
system and are sure of what they are doing) Takes three parametrs

* system segment nubmer
* offset within that segment
* type of the pointer to be created.


### System Hacking intrinsics

require that the user have knowledge of how the compiler generates code.
Folks playing with thise may find the QCode disassembler (QDIS) to be useful
if the desired results were produced.

* MakeVRD - load a variable routine descrptior for a procedure or function. (c.f. Routine Calls and Returns" in the QCode ref manual). It's left on the expression stack
* InLineByte - place explicit bytes directly into the code stream. Useful for inserting actual QCodes into a program.
* InLineWord - place explicit words directly into the code stream
* InLineAWord - place explicit words directly into the code stream.  Placed on the next word boundary of the code stream.
* LoadExpr - takes an arbitrary expression and "loads" the value of the expression.  The result is wherever the partcular expression type would norally be loaded (expression stack for scalars, memory stack for sets, etc)
* LoadAdr - loads the address of an arbitrary data items onto the expression stack. May include array indexing, pointer dereferencing, and field selections.  The address that's left on the expression stack will be a virtual address (if the parameter includes either the use of a VAR parameter or a pointer derefernce), otherwise a 20-bit stack offset.
* StoreExpr - stores the single word on top of the expression stack in the variable given as a parameter.  The destination must not require any address computation - must be local, intermediate or global.  Must not be a VAR. if a record, a field specification may be given.
* Float - converts integer into floating point nubmer
* Stretch - converts a single precision integer to double-precision
* Shrink - converts double precision itneger to a single. If outside -32K+32K, a runtime error happens


### Command line and compiler switches

`COMPILE [<InputFile>] [~ <OutputFile>] { </Switch> }`

InputFile is name of the source file.  it's searched for. if not found,
Intputifle.pas is searched for.  otherwise user prompted. If not specified, the compiler uses the last file name remembered by the system

OutputFile contains the output of the compiler.  .SEG is the default
extension to use, if not already present.  

</Switch> is the name of a compiler switch.  Can use /HELP switch.

If invoked from a command file - if there's errors in the command line, it
logs it into `CmdFilePascal.ERR` in the local directory.

Switches can be set on the command line, or via {$SWITCH}

The actual switches "bear little resemblance to those described in standard pascal"

#### File Inclusion

Include the contents of another source file : `{$INCLUDE FILENAME}`. If filename does not exist, .PAS will be added.

Can be used anywhere in a program or module, results as if the entire contents
of the file were contained in the primary source file.

#### List

`{$LIST <filename>}`  or `/LIST [=<filename>]`

The listing file has each line, the line number, segment number, and procedure number.

#### Range Checking

* `{$RANGE+}` or `/RANGE` to enable
* `{$RANGE-}` or `/NORANGE` to disable
* `{$RANGE=}` resumes state of range chekcing whcih was in force before the prior Range-/+

`+` is assumed if not supplied

#### Quiet

Displaying (or not) the name of each procedure and function as it is 
compiled.

* `{$QUIET+}` or `/VERBOSE` to turn on
* `{$QUIET-}` or `/QUIET` to turn off
* `{$QUIET=}` restore value in force before most recent change


#### Symbols

Set the number of symbol table swap blocks used by the compiler. As the
number increases, compiler execution becomes shorter, but physical memory
requirements increase.  No comment form.

* `/SYMBOLS=<# of symbol table blocks>`

The default and the max are dependent on the size of memory.
With 256K, they aae 24 and 32. After 32 performance degrades considerably.  For
512 or 1024, 200/200 are the values.

#### Automatic RESET/REWRITE

it automatically generates RESET(INPUT) and REWRITE(OUTPUT). Can be
disabled

* `{$AUTO+}` or /AUTO
* `{$AUTO-}` or /NOAUTO

If the comment form is used, must precede the BEGIN of the main body
of the program

#### Procedure / Function Names

Can generate a table of procedure and function names at the end of
.SEG file.  May be useful for debugging.

* `{$Names+}` or `/NAMES`
* `{$Names-}` or `/NONAMES`

The debugger and the disassembler use the information stored in the name
table. _(guessing this is modern-day "debug symbols")_


#### Version Switch

Inclusion of a version string in the first block of the .SEG file.
(max 80 characters).  Not used by any other PERQ software, but can be
accessed by user programs to identify .SEG files

* `{$VERSION <string>}` or `/VERSION=<string>`


#### Comment Switch

inclusion of arbitrary text in the first block of the .SEG. Useful
for copyright notices

* `{$COMMENT <string>}` or `/COMMENT=<string>`

#### Message

causes the text to to be printed when parsed.  (essentially like #warning)

* `{$MESSAGE <string>}`

#### Conditional Compilation

`{$IFC <boolean expression> THEN}`

blah blah blah

`{$ENDC}`

there's also `{$ELSEC}`. Can be nested.

#### Errorfile

When errors detected, displays error information and requests if want to 
continue.  `/ERRORFILE [=<filename>]` overrides this action.  Uses .ERR
file extension.

The error file is always fresh (if it exists)

#### Help

can get help with `/HELP`

### QUIRQS

* for loops with upper bound > 32,766 are infinite
* the last line of program or module must end with a CR (otherwise unexpected end of input error)
* most {$ abbreviations work, except for the conditional compilation and include ones - gott aspell them out
* procedures and functions which are forward declared and contain procedure parameters may not have their lists redeclared at the site of the procedure body (lame!)
* the compiler permits the use of an EXIT, specifing another procedure at the same lexical level. If there's no invocation on the runtime stack, the PERQ Hangs
* filenems given in IMPORTS must start with an alphabetic character
* record comparisons involving packed records will not be caught unless
  PACKED appears explicitly in the record defiition. (so if it's hidden
  in a type, then you can try a record comparison in error)
* reals and longs can't be used together in an expression
* the compiler will not detect and error in the definiton or use of
  a set that exceeds the set size
* Many functions for integers (like LAND) are not implemented for longs.
* RECAST does not work with two-word sclars (LONG) and arrays


## Graphics API n'at

```
Procedure Line(Style: LineStyle; X1, Y1, X2, Y2: integer; Origin: RasterPtr);
{-----------------------------------------------------------------------------
 Abstract: Draws a line.
 Parameters: Style - function for the line;
             X1, X2, Y1, Y2 - end points of line.
             Origin - pointer to the memory to draw lines in.
                      Use SScreenP for Origin to draw lines on the screen.
(using TLATE0, QLINE)
        LineStyle = (DrawLine,EraseLine,XorLine);
```

```
Procedure SVarLine(Style: LineStyle; X1, Y1, X2, Y2, Width: integer;
                   Origin: RasterPtr);
{-----------------------------------------------------------------------------
 Abstract: Draws a line.  Same as Line except it takes the buffer width as
           a parameter.  This is only useful when drawing lines in off-screen
           buffers.
 Parameters: Style - function for the line;
             X1, X2, Y1, Y2 - end points of line.
             Width - the word width of the "origin" buffer.
             Origin - pointer to the memory to draw lines in.
                      Use SScreenP for Origin to draw lines on the screen.
```

```
Procedure SLine(Style: LineStyle; X1, Y1, X2, Y2: integer; Origin: RasterPtr);
{-----------------------------------------------------------------------------
 Abstract: Draws an line relative and clipped to the current window;
 Parameters: Style is function for the line; X1, X2, Y1, Y2 are end points of
             line relative to current window (i.e. 0,0 is upper left corner of
             home char).  Origin is pointer for Screen;
 SideEffects: Draws a line on the screen
-----------------------------------------------------------------------------}
```

```
Procedure SRasterOp(Funct, Width, Height, DestX, DestY, DestWidth: Integer;
                    DestP: RasterPtr; SourceX, SourceY, SourceWidth: Integer;
                    SourceP: RasterPtr);
{-----------------------------------------------------------------------------
 Abstract: Does a RasterOp relative and clipped to the current window;
 Parameters: Same as for RasterOp; does relative to current window for dest if
             destP = SScreenP and for source if sourceP = SScreenP
 SideEffects: Does a rasterOp on the screen
-----------------------------------------------------------------------------}
```

```
  Const RRpl    = 0;       { Raster Op function codes }
        RNot    = 1;
        RAnd    = 2;
        RAndNot = 3;
        ROr     = 4;
        ROrNot  = 5;
        RXor    = 6;
        RXNor   = 7;
        
  Type RasterPtr = ^RasterArray; {a pointer that can be used as RasterOp 
                                    or Line source and destination }
       RasterArray = Array[0..0] of integer;
```

```
  CursorPattern = array[0..63,0..3] of integer;
  CurPatPtr = ^CursorPattern;

Procedure IOLoadCursor(Pat: CurPatPtr; pX, pY: integer); 
                                           { load user cursor pattern }         
```


```
Function IOCPresent( Unit: UnitRng ): boolean;

{----------------------------------------------------------------------------
{
{  Abstract:
{
{       Returns true if the Unit is a character device and has a character
{       available for reading.  Otherwise it returns false.  It does not
{       read the character.
(iounit.pas)
```

 

## Editor

`edit file-name.pas`

The docs/tutorial is poorly organized.


### Selection

left button (button 1) to select character. click again to select word. click again to select line.

middle button (button 2) to select words.  click again to select line.

right button (button 3) to extend the current selection without changing the other extreme of the selection.

For four button puck,
* white - character
* yellow - word
* green - extend
* blue - line

If you don't want to click, can use `e` to extend the selection, kind of like how modern textfields behave.  Uses the selection type last used (?)

`*` selects the entire file

Character selection has some shortcut keys

* ` ` (space) - move the character selection after the current selection
* `backspace` / `^H` - move to before the current selection
* `TAB` - move forward 5 characters
* `^TAB` - move backward 5 characters
* `^backspace` - move backward by word
* `RETURN` / `^U` - move to beginning of next line
* `^RETURN` / `^OOPS` - go backwards beginning of prior line. Both returns skip empty lines.

More stuffs:

* `G` - Go to a character.  Searches "the current screen". Obeys the direction.  INS will repeat it
* `W` - select next/prev word
* `^W` - select first character of next/prev word. obeys repeat count
* `L` - select line.  If line selected, selects next line. obeys direction / repeat count
* `M` - "more", preserves existing selection when doing the above goodies.

### Keys

text modification commands are terminated with the "accept" (INS) key 
or "reject" (DEL).

when inserting, can delete with
* backspace the most recently typed character
* control-backspace the most recently typed word
* control-OOPS most recenlty typed line, up to and including the CR.

To quote keys (like ^V in emacs), do a control-"

At command level:
* INS - repeats the last command (for a subset of commands) - A, I, R, S and those that move selection
* typing a 1-4 digit number enters a repeat count
* `>` - change to forward-direction (small sigil on left-side of top line)
* `<` - change to backward-direction -  these affect Find, Replace, Word, Line, and goto character


### Scrolling / Navigating

left-side of the text area.  when mousing over it, cursor turns into a down arrow (when near the vertical line) or an up arrow (further away).

* click next to a line while having the up arrow, puts that line at the top.
* clicking with down arrow will scroll to earlier in the document, proportional
  to how far you're down the screen
* middle button scrolls down
* right button scrolls up
* `T` puts the selection at the top of the window (unless it's offscreen, then it's put at the bottom, or maybe the middle)
* `B` puts the selection at the bottom of the window (same)

The top margin line is the "thumb bar" - the cursor turns into a circle when hovered over.  it's like a thumb trough, but 90-degrees out of phase with the document. "rapidly move around your file. But it's not very precise.  ASCII-art styles:

* `<` - end of file (actually, a black triangle, not a less-than sign)
* `S` - start of selection. Can click on this to scroll to the selection
* `(` and `)` - showing range of displayed text
* `N` - position of the Noted (?) display
* `O` - position of the display at the last thumbing. _(I have no idea what this means)_
* `X` - somewhat baffling line "similar control can be achieved with the X command", which puts an X into the thumb bar, and needing to INS/DEL to get out of.

!!! There's stuf on page 10 I just don't understand.



### Finding

`F` Finds a character string.  

Do `F`, then type your string, then accept (INS) or reject (DEL).  The matching string will be highlighted.

 `F ACCEPT` will use the prior search string (displayed in the top status-y area).

Matching is emacs-style: lowercase matches everything, uppercase only matches uppercase.  Long finds can be interrupted with ^C

direction is honored, if you want to search backwards, change the direction with `<` and then do your `F`ind.


### Text Modification

Commands:

* Insert
* Append
* Substitute
* Replace
* Delete

Insert and Append operate before and after the current selection.  THe others
work on the current selection.

Except for delete command, the function can be re-executed by doing INS, say for inserting the same text in a number of places.

If you press INS after a delete command, the deleted text is reinserted. (you can delete, and re-insert in multiple places).  Handy for quick copy/paste.

At the top of the screen are some indicators

```
I{}
D{}
F{}
R{}
S{}
```

they have the contents (or an elided form) of the last (accepted) things inserted, deleted, finded, replaced, and substituted.  If you do the op, and then press INS, it'll use that content

For replacement:

* `R`
* type search term. will appear in the `F{}` dingus
* type `INS`
* type replacement term. For empty replacement (delete), type a character and backspace.  Will appear in the `R{}` dingus.
* type `INS`
* see a `C1` count up as it replaces stuff.
* ^C to interrupt.

a repeat count will limit the number of changes. not repeat count means all the things.

`V` - verify mode, is like emacs query replace.  Pressing `V` puts a V in the top line.  Do your find and replace as normal. For each one, will stop - INS to replace and move on, space to skip and move on, DEL to stop the whole process.  Many things clear the V flag automatically.

Substitute - the docs say it's easy to confuse this with Replace.  It replaces the selceted text with new text, like doing a `D`elete followed by an `I`nsert.  The currently selected text is still in the buffer while you're putting in the new text, so it can be confusing for folks used to modern textfields.  There's no real way to undo a substitute.


### Misc

only the left-shift works.  So doing ":" with right shift gives you ";".

There is a log kept of actions performed in the session, stored in `>Editor.Transcript`

Can replay stuff with `Editor/Replay`

* space - stop replaying after next character or puck press
* CR - stop replaying after a CR in I command or after next command if not in I command
* LF - stop replaying after next command
* INS - begin replaying and stop when one of the above keys is types
* DEL - exit replya mode.

It'll replay against the prior-save file (SPLUNGE.XYZ$)


