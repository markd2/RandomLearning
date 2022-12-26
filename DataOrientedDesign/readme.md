# Data-Oriented Design

* [Dungeon](dungeon) - play with stuff in a real (toy) application


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
* _Efficiency with Algorithms, Performance and Data Structures_ - talk by Chandler Carruth cppcon - https://www.youtube.com/watch?v=fHNmRkzxHWs&t=13s
    - nice definitions of efficiency and performance (lighting up all the transistors)
    - includes the Jeff Dean latency chart around 37:10

And to consume:

* _Data-Oriented Design_ blog by Noel Llopis - http://gamesfromwithin.com/data-oriented-design
* _Eficiency with Algorithms, Performance with Data Structures" - talk by Chandler Carruth - https://youtube.com/watch?v=fHNmRkzxHWs
* _Data Oriented Programming: Reduce complexity by rethinking data_ book - https://www.amazon.com/Data-Oriented-Programming-Unlearning-Yehonathan-Sharvit/dp/1617298573/ref=pd_lpo_1?pd_rd_i=1617298573&psc=1
    - haven't read yet - comes out July 2022
* _Dungeon Siege Architecture" https://www.gamedevs.org/uploads/data-driven-game-object-system.pdf | https://dungeonsiege.fandom.com/wiki/Guide:_Siege_University_-_301:_Introduction_to_Dungeon_Siege_Architecture
    - recommended in Chapter 4, Component Based Objects
* _10000 Update() calls_ - https://blogs.unity3d.com/2015/12/23/1k-update-calls
    - also recommended in Chapter 4, something about crossing C++ and scripting language (C#) boundary and calling `Update()` on every tick, and "why the move to managers makes so much sense"
* _The Massively Vectorized Virtual Machine_ - (though not finding a section with that name).  Here are some posts in the orbit of Autodesk Stingray (discontinued 2018)
  - http://bitsquid.blogspot.com/2012/09/a-data-oriented-data-driven-system-for.html (A Data-Oriented, Data-Driven System for Vector Fields - Part 1)
  - http://bitsquid.blogspot.com/2012/10/a-data-oriented-data-driven-system-for.html (Part 2)
  - http://bitsquid.blogspot.com/2012/10/a-data-oriented-data-driven-system-for_17.html (Part 3)
* _Single-Assignment C_ : https://www.sac-home.org/index  
* _What Every Programming Should Know About Memory_ : https://akkadia.org/drepper/cpumemory.pdf - PDF by Ulrich Drepper (2007)
* _Slashdot interview with Alexander Stepanov and Daniel E. Rose_ : https://interviews.slashdot.org/story/15/01/19/159242
  - huh. TIL Slashdot is still a thing.
  - From DoD Book: "some decisions made when STL was first conceived have negative consequences with today's hardware"
    - specifically node-based data structures. (e.g. a B* tree being a better choice than red-black)
* _Evolve your Hierarchy_  : https://cowboyprogramming.com/2007/01/05/evolve-your-heirachy/, converting Tony Hawk code to components.

## Cachce as cache can

* Intel 64-bit has 64-byte cache line
* Apple M1 has 128-byte cache line
    - some sysctls to use - https://news.ycombinator.com/item?id=25660467
    - hardware properties and topology - https://cpufun.substack.com/p/more-m1-fun-hardware-information
* `sysctl -a hw machdep.cpu`
* _The M1 doubles the line size, doubles the L1 data cache (i.e. same number of lines), quadruples the L1 instruction cache (i.e. double the lines), and has a 16x larger L2 cache, but no L3 cache."_ (https://news.ycombinator.com/item?id=25660626)
    - _sysctl on m1 contains the cache sizes for the little cores (since those are CPUs 0-3) big cores (CPU4-7) have 192KB L1I and 128KB L1D._

### Cache-friendly data structures

* Judy Array - https://en.wikipedia.org/wiki/Judy_array
* Cache-friendly linear binary search in _Data-Oriented Design_

## Tools

- https://drawsql.app/ - (haven't used yet) - designing and visualizing 
  database design, could be useful for diagramming DoD

## Sessions to watch / concepts to research

* _C++ Seasoning_ - Sean Parent (https://www.youtube.com/watch?v=W2tWOdzgXHA).
  (slides: https://sean-parent.stlab.cc/presentations/2013-09-11-cpp-seasoning/cpp-seasoning.pdf)
* Aspect Oriented Programming - mentioned in "Data-Oriented Design" when talking about
  using tables to register interest in events.  _"This coding style is somewhat
  reminiscent of Aspect-Oriented Programming"_, page 80
