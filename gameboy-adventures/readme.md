# Gameboy Coding Adventure

OMG there's an actual NEW BOOK about retro programming.  Flipping
through it at Third Place Books in Seattle, it looks pretty incredible.
Been a while since I've torn into a good applied programming book
that was written in the last 30 years.

Using ICS techniques for learning.  And Making some Buffl.com flashcards
([deck link](https://app.buffl.co/join/course/e97e0c10-b85c-11f1-acba-adac25b6f639))

yay!

## ToolZ

* RGBDS - the toolchain.  https://rgbds.gbdev.io
* SameBoy - emulator.  Too lazy to jump through the hoops for BGB.  Don't
  know if that'll affect e.g. debugging later on. 
* OK, I jumped through the hoops for BGB.  Got "Porting Kit", made a new 
  dingus for BGB, which is gottenable from https://bgb.bircd.org

Book githubbe at https://github.com/mdagois/gca

Debugger info at https://bgb.bircd.org/manual.html

Hello World:

```
def ROM_HEADER_ADDRESS    equ $0100
def ROM_MAIN_ADDRESS      equ $0150

section "header", rom0[ROM_HEADER_ADDRESS]
    di
    jr main

section "main", rom0[ROM_MAIN_ADDRESS]
main:
    ld a, 0
    .loop
        ld [$C000], a   ; [$C000] = A, so initialize that location in memory
                        ; $C000 is start of WRAM
        inc a
        jr .loop        ; forever and ever
```

Building a ROM

* `rgbasm -Werror -Weverything -o main.o main.rgbasm`

I don't like -Werror.  I'm dedicated enough not to let warnings through, but
sometimes they're transient and I don't want to have to continually edit
build commands, so

* `rgbasm -Weverything -o main.o main.rgbasm`

The the linking

* `rgblink --dmg --tiny -o sample.gb main.o`

And then the fixing - put in header, validate ROM, etc. the ROM is modified
in-place

* `rgbfix --title game --pad-value 0 --validate sample.gb`

0 is NOP, which is nice

The three steps above are "compilation"

Gotta copy the ROM into the BGB wrapper:



mkdir a ROMS directory, and copy into that.

```
cp dingus.md '/Applications/BGB Emulator.app/Contents/SharedSupport/prefix/drive_c/ROMS/'
```

--------------------------------------------------
## Some Fun Self-Inflicted Experiments

While reading through the book and making Notes(tm), various questions
come to mind, and "huh, what would it look like if I did ____", so here
are some things I tried.

* Change background palette on frame update