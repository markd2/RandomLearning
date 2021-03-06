# Data-Oriented Design

"Helping set up things the way you want in memory without loss of efficiency and high-level expressiveness"

* _Data-Oriented Design_ book  by Richard Fabian - https://www.amazon.com/Data-oriented-design-engineering-resources-schedules/dp/1916478700
    - don't get the Kindle version - it's one of those "adhere to the pagination of the printed book" versions
    - could defintely use an editor (so many run-on sentences...) and better layout (keeping code samples 
      near their discussion), but a ton of cool ideas
    - Finished, a lot of cool ideas (like the cache-aware linear binary search). Would have liked to have
      seen actual data oriented design before the code dump in chapter 16.  "just add stuff to a table",
      well, what does that actually look like?  The OOP hate got tedious.
* _Data-Oriented Design and C++_ talk by Mike Acton - https://www.youtube.com/watch?v=rX0ItVEVjHc
    - amusing that it hits the audience like a lead balloon.  
* _OOP is Dead, Long Live Data-oriented Design_ talk by Stoyan Nikolov - https://www.youtube.com/watch?v=yy8jQgmhbAU&t=2794s
* Mature Optimization Handbook - PDF Book by Carlos Bueno - https://carlos.bueno.org/optimization/
    - mainly server-side tools and techniques, but does focus on "next level" thought processes beyond
      introductory profiling and sampling.
* _Data-Oriented Demo: SOA, composition_ - video by Jonathan Blow - https://www.youtube.com/watch?v=ZHqFrNyLlpA
    - only watched the first bit.  Some "OO makes it hard to do X", some on structure of arrays, and how
      it's expressed in the new language.


And to consume:

* _Data-Oriented Design_ blog by Noel Llopis - http://gamesfromwithin.com/data-oriented-design
* _Eficiency with Algorithms, Performance with Data Structures" - talk by Chandler Carruth - https://youtube.com/watch?v=fHNmRkzxHWs
* _Data Oriented Programming: Reduce complexity by rethinking data_ book - https://www.amazon.com/Data-Oriented-Programming-Unlearning-Yehonathan-Sharvit/dp/1617298573/ref=pd_lpo_1?pd_rd_i=1617298573&psc=1
    - haven't read yet - comes out July 2022

## Cachce as cache can

* Intel 64-bit has 64-byte cache line
* Apple M1 has 128-byte cache line
    - some sysctls to use - https://news.ycombinator.com/item?id=25660467
    - hardware properties and topology - https://cpufun.substack.com/p/more-m1-fun-hardware-information

### Cache-friendly data structures

* Judy Array - https://en.wikipedia.org/wiki/Judy_array
* Cache-friendly linear binary search in _Data-Oriented Design_
