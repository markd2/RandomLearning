# PERQ Image Tools

Welcome to MarkD's land of yak-shaving!

The goal of all of these is "create some graphics assets on the Mac side using Acorn
and then get them into PERQemu for RasterOp fun and excitement."

## TL;DR

programs in caps are PERQ Pascal programs, built and run on the PERQ

* `BIN2ASCII` - convert a binary file (any file, actually) to a 7-bit ASCII interchange file, on the perq side
* `ASCII2BIN` - convert a 7-bit ASCII interchange file to binary, on the perq side.
* `bin2ascii` - same as BIN2ASCII, but mac-side
* `ascii2bin` - same as ASCII2BIN, but mac-side
* `pic2png` - convert a PERQ "pic" format (described in SIGUTILS.PAS) to png
* `png2pic` - convert a png to a PERQ "pic"
* `ROOSTEROOP` - display a .pic file on the PERQ side.

## Typical workflow

all of the "2" programs take two arguments.  First is the sourece filename,
second is where to save the converted data.

ROOSTEROOP takes a single argument, the name of a .pic file

### Get an existing image off of PERQemu (optional)

* use BIN2ASCII to convert the PIC to a text file
* `COPY filename.ext RSX:\users\username\Downloads\filename.ext` to get it to the mac side
* ascii2bin for text->binary
* pic2png for binary->png
* edit the png
* png2pic for png->binary
* bin2ascii for binary->ascii
* copy the ascii file to downloads
* `COPY RSX:\users\username\downloads\filename.ext filename.ext` to get it into PERQemu
* ASCII2BIN
* now you can `LoadPicture` and `RasterOp` to your heart's content

