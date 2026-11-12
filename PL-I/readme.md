# PL/I

Maybe doing Advent of Code 2026 in PL/I.

Good lord why? 

Two reasons.  First is I've been PL/I curious / adjacent in my past.  
Taking summer classes at UALR in high school (FORTRAN and VAX assembly), 
all my peers were doing their CS classes mostly in PL/I on the campus
VAX cluster.  It looked :alot: like Pascal, which I already knew, so I
didn't pay it much heed.

These days (late 2026) I'm volunteering at a [Computer History Museum](https://lssmuseum.org)
and we have VAXen **and** a lot of working IBM mainframes. And of course
we have PL/I on those.  I eventually want to program everything in the
building, so I'll want PL/I to program these guys on.

Pluse [Advent of Code](https://adventofcode.com) is a great way to get over the hump of first using a
new language.  All you need is the baseline "get the thing installed, write
a hello world, open and read a file" and you're off to the races.  
Early AoC problems can often be solved with accumulator variables.  That gives
some time figuring out how data structures and algorithms are expressed in
the language. Sometimes I hit a very tall barrier and give up (like for FORTRAN needing
a dictionary/associative-array/hash table, given kind of annoying string
handling.).  Or what most often happens is December gets complicated and
I ended up no longer having the time.  It's all love, though.

# Deets

## Compiler

[Iron Spring](https://iron-spring.com) has a PL/I compiler for Linux. There's not a native one for
the Mac (which is my usual daily driver).  I have access to VAXen and
IBM mainframes here at the museum.  So I could run simh or hercules at
home, but I kind of want to stick with comfortable tools.  Absorbing
a new language, especially one that's a chonker like PL/I, will be enough.

I've gotten that installed.  Files in this directory are pl/i playing, and
advent of code jazz will be over at my somewhat embarassing [Advent of Code Repo](https://github.com/markd2/adventofcode).

## Emacs Mode

No pl1 mode in the standard emacs package ecosystem. There is a mode at 
https://github.com/marcoxa/iron-main . Do a `M-x package-vc-install`, then
paste in that URL.  Finally, add this verbage to your `.emacs.`:

```
(require 'pl1-mode)
(add-to-list 'auto-mode-alist '("\\.\\(pli\\|pl1\\)\\'" . pl1-mode))
```

To insert the PL/I "not" character `¬`: `Ctrl-X 8 [RET] 00ac [RET]`


# Building

There's a makefile here taken from "SA_Make" from the iron-spring samples
directory, that compiles a stand-alone sample linking against the PL/I
library (not anything C-related).  I'm planning on staying inside the 
iron-spring ecosystem, so that's ok.  `make blah` is good enough.

