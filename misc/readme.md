# Misc stuff

Things that are small enough to not deserve (sorry!) their own directory.


## FORTRAN

Doing some F77 stuff, and want to do it locally rather than trying to get
decent VT-220 PLUS KEYPAD emulation working on this lappy.  (Modern keyboards
that aren't laptops have a unified key where the VT-220 has two keys, so you
lose some of the EDT editor functionality. Not that you care.  Thank you 
for reading. who are you, and are you enjoying yourself? If so, drop me
a line at markd@borkware.com)

```
brew install gcc
```

Will give gfortran. Run like any standard compiler:

```
% gfortran test.f -o test
% ./test
```

WRITE to device 6.

