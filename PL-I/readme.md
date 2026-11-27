# PL/I

(tmux tricks - split vertically with ^B % , switch with ^B o
)

Maybe doing Advent of Code 2026 in PL/I.

Good lord why? 

Two reasons.  First is I've been PL/I curious / adjacent in my past.  
Taking summer classes at UALR in high school (FORTRAN and VAX assembly), 
all my peers were doing their CS classes mostly in PL/I on the campus
VAX cluster.  It looked :alot: like Pascal, which I already knew, so I
didn't pay it much heed.  Plus I was a know-it-all punk.  _(as opposed to
now where I'm a know-it-all punk old guy)_

These days (late 2026) I'm volunteering at a [Computer History Museum](https://lssmuseum.org)
where we have VAXen **and** a lot of working IBM mainframes. And of course
we have PL/I on those.  I eventually want to program everything in the
building, so I'll want PL/I to program these guys on.

Plus [Advent of Code](https://adventofcode.com) is a great way to get over the hump of first using a
new language.  All you need is the baseline "get the thing installed, write
a hello world, open and read a file" and you're off to the races.  
Early AoC problems can often be solved with accumulator variables.  That gives
some time figuring out how data structures and algorithms are expressed in
the language. Sometimes I hit a very tall barrier and give up (like for FORTRAN needing
a dictionary/associative-array/hash table, given kind of annoying string
handling in the language).  Or what most often happens is December gets complicated because
of the crazy music schedule and I end up no longer having the time.  It's all love, though.

# Deets

Interesting books:
  * "Programming for Poets, A gentle Introdcution Using PL/I" - what it says on the tin.  It's a
    REALLY good (at 15% into it) intro for non-programmers who want to learn how program logic
    works.  Plus it's a very gentle introduction to the language.
  * "Programming Languages (Comptuer Science Series)" - a comparison / cookoff between ALGOL,
    FORTRAN, COBOL, PL/I, RPG, and SNOBOL(!).  Each language gets a technical deep-dive of features.
    Then there's three over-arching problems which each get implemented in several languages, with
    a compare-and-contrast.  PL/I ended up second-best in about everything. Not as good as the
    specialized languages (like FORTRAN for math and COBOL for businessy stuff), but a close
    second.

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

To insert the PL/I "not" (NOT) character `¬`: `Ctrl-X 8 [RET] 00ac [RET]` . On IBM-ecosystem keyboards,
it's Shift-6.


## Building

There's a makefile here taken from "SA_Make" from the iron-spring samples
directory, that compiles a stand-alone sample linking against the PL/I
library (not anything C-related).  I'm planning on staying inside the 
iron-spring ecosystem, so that's ok.  `make blah` is good enough.


# Language Stuffs

- if `get list (number1, number2)` seems to hang, be sure to enter enough stuff to satisfy all of if.
  e.g. something like `1234 2345 [RET]`. It seems to want a space after things. Strings need to
  be delimited with single quotes
- print with `put skip list`
- numbers will print in scientific notation. Use `fixed(numvar)` to print out decimal styles
  (truncating decimals)
- declare string with `declare (str) character(100) varying;`
- typos in varaible names are implicitly given types.  got bitten by that...


### Misc

Comments are `/* ... */`, newlines ok.  Can't nest.

Whitespace between tokens is fine, as are newlines. Jsut don't split an element (like a keyword or
literal string)


### loops

```
    printloop: do loopcount = 1 to 3 by 1;
        get list (st);
        put skip list (st);
        end printloop;
    end program;
```

can of course use variables for things, and can elide the 'by 1' _(get one free)_

Declare values like `declare blah decimal;`.  Also `declare (oop, ack)
character(100) varying` - the parentheis are factoring-parens, so the
type/options are applied to each of the goodies in the parens.

### ifs

```
if i <= 3 | i >= 7 THEN DO; 
    put skip list (value);
end;
```

The DO;END; is like bracing an if in C (and prevents the same classic class of errors).
Could do `IF BLAH THEN OOP; ELSE ACK;`


### comparisons

for string comparisons, the shorter string is padded with spaces.  spaces always sort
lexically less than everything else.  digits sort after letters.

sort order:

```
'b' . < ( + & $ * ) ; ¬ - / , % _ > ? : # @ ' = " A-Z 0-9
```

### I/O

`PUT SKIP LIST (VAR);` prints out var.  do `FIXED(VAR)` if you're getting unwanted scientific notation.

Literals are ok,  `put skip list ('greeble bork');`

Print out multiple values with `PUT SKIP LIST (OOP, ACK, BILL);`

`GET LIST (var);` - can also have multiple variables in there.  `GET LIST (oop, ack, blorf);`

They print out in tab stops. five columns is standard. (poet-book) "PL/I has very elaborate and flexible
facilities for formatting output", which I'll get to eventually. Appendix B.4 has some more info

When entering values, put a space after the name
```
'oop' |----
'ack' |----
'greeble' |----
```


