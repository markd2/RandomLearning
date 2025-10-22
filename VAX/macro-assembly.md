# MACRO (assembly)

MACRO is the VAX/VMS assembler / assembly language.

Documents:

* [VAX Assembly Language](https://www.ebay.com/itm/197483025694) second edition by Sara Baase - **fantastic** book introducing VAX assembly language.  I learned from (and taught from(!)) the first edition of this book in the late 80s.
* [VAX-11 MACRO Language Reference Manual (1980)](http://www.bitsavers.org/pdf/dec/vax/vms/2.0/AA-D032C-TE_VAX-11_2.0_Macro_Language_Reference_198003.pdf) / [2019 edition(https://vmssoftware.com/docs/VAX_MACRO_INSTRUCTION_SET_REF.pdf)


# Snippets

Each snippet is surrouned by a line.

----------
byte
8-bits
#integer #data #storage

----------
word
16 bits
2 bytes

#integer #data #storage

----------
alignment of data types not required, but more efficient

#data #storage #alignment

----------
long word
32 bits
4 bytes

#integer #data #storage

----------
quadword 
64 bits
8 bytes

#integer #data #storage

----------
octaword
128-bits 
16 bytes

#integer #data #storage

----------
variable length bit field 

arbitrary string of (up to 32) consecutive bits, ignoring byte boundaries

#bitfield #variable-length

----------
page size
512 bytes

#page #memory
----------
bit range notation
high-bit-position:low-bit-position, inclusive

e.g. the high byte of a word would be bits 15:8

```
+---- this range -------+
v                       v
+--+--+--+--+--+--+--+--++--+--+--+--+--+--+--+--+
|15|14|13|12|11|10| 9| 8|| 7| 6| 5| 4| 3| 2| 1| 0|
+--+--+--+--+--+--+--+--++--+--+--+--+--+--+--+--+
```

#bit #range #notation 

----------
General purpose registers

32 bits

R0...R11 are free use
R0 can be clobbered by I/O instructions
R0...R5 can be clobbered by some instructions
R6...R11 are safe from clobberin' time

AP/FP/SP/PC are technically general purpose registers, but have special uses

#register

----------
AP - argument pointer register

#register #ap #procedure-call

----------
FP - frame pointer register

#register #fp #procedure-call

----------
SP - stack pointer register

#register #sp #stack #procedure-call

----------
PC - program counter register

#register #pc

----------
When accessing a byte in a register, the  lowest (least significant) are used

#register #integer #byte

----------
little endian

The VAX is little endian

#integer #endian #little-endian

----------
PSL - processor status longword

32 bits of flags

low-order word is the PSW (processor status word)
high-order word is reserved by the system

#register #status #flags
----------
PSW - processor status word

16 bits of flags

----------
RMS - Record Management Services

handles file organizationh and I/O for the user

#rms #record #file #i/o
