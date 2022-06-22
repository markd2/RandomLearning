# Data-Oriented Design

* _Data-Oriented Design_ book  by Richard Fabian - https://www.dataorienteddesign.com/dodmain/
    - don't get the Kindle version - it's one of those "adhere to the pagination of the printed book" versions
    - could defintely use an editor (so many run-on sentences...) and better layout (keeping code samples 
      near their discussion), but a ton of cool ideas
* _Data-Oriented Design and C++_ talk by Mike Acton - https://www.youtube.com/watch?v=rX0ItVEVjHc
    - amusing that it hits the audience like a lead balloon.  
* _OOP is Dead, Long Live Data-oriented Design_ talk by Stoyan Nikolov - https://www.youtube.com/watch?v=yy8jQgmhbAU&t=2794s

## Cachce as cache can

* Intel 64-bit has 64-byte cache line
* Apple M1 has 128-byte cache line
    - some sysctls to use - https://news.ycombinator.com/item?id=25660467
    - hardware properties and topology - https://cpufun.substack.com/p/more-m1-fun-hardware-information

### Cache-friendly data structures

* Judy Array - https://en.wikipedia.org/wiki/Judy_array
* Cache-friendly linear binary search in _Data-Oriented Design_
