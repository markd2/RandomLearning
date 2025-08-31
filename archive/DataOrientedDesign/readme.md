# Data-Oriented Design

* [Dungeon](Dungeon) - play with stuff in a real (toy) application


"Helping set up things the way you want in memory without loss of efficiency and high-level expressiveness"

* _Data-Oriented Design_ book  by Richard Fabian - https://www.amazon.com/Data-oriented-design-engineering-resources-schedules/dp/1916478700
    - don't get the Kindle version - it's one of those "adhere to the pagination of the printed book" versions
    - could defintely use an editor (so many run-on sentences...) and better layout (keeping code samples 
      near their discussion), but a ton of cool ideas
    - Finished, a lot of cool ideas (like the cache-aware linear binary search). Would have liked to have
      seen actual data oriented design before the code dump in chapter 16.  "just add stuff to a table",
      well, what does that actually look like?  The OOP hate got tedious.
* _Game Programming Patterns_ book by Robert Nystrom - https://www.amazon.com/Game-Programming-Patterns-Robert-Nystrom/dp/0990582906
    - I've only read the "Data Locality" chapter so far, and it's a great overview of
      many things the Fabian book talks about.
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
* _The Art of Writing Efficient Programs: An Advanced Programmer's Guide to efficient hardware utilization and compiler optimizations using C++ Examples_ - book by Fedor G. Pikus - https://www.amazon.com/Art-Writing-Efficient-Programs-optimizations/dp/1800208111
    - hugely information dense
    - covers memory architecture, locking strategies, micro benchmarking (and its pitfals)
    - If you can, read from O'Reilly(a.k.a. Safari Bookshelf).  The printed versions's display of source code is eye-bleedingly terrible.

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
* _Data Oriented Design (DigiPen)_ : https://www.youtube.com/watch?v=16ZF9XqkfRY
* _Data-oriented Design in practice_ : https://www.youtube.com/watch?v=NWMx1Q66c14


## Cache as cache can

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



## Talk notes

### DigiPen GEAC

(Game Engine Architecture Club)

https://www.youtube.com/watch?v=16ZF9XqkfRY

* DoD focuses on making tightly packed contiguous chunks of memory for data structures
* Focues on algoirthms that process a single task (e.g. physics) in a single
  tight loop before moving on to the next task (e.g. graphics)
  - not mixing and matching
* Maximizes efficiency, simplifies architecture

* Focuses on POD (plain old data), simple c-like structure
* external (to the type) methods/logic
* Focuses on data rather than the behavior

* Stresses removal of data dependencies (like component systems)
* each composite type (struct/class) should have all data it needs
  in itsel, with no dependencies (pointers/implied references) to
  other types
* Makes it easy(?) to multi-thread and write efficient processing
  loops over data

* DoD is mainly for performance

* OOP problem with `update` on objects - updating all the things in
  a loop, on a per-object basis doing physics/graphcs/other for one, the
  those three for the next, and the next

* modern CPUs have deep pipelines (like an automobile factory)
  - any pipeline stall and the wait state cna have serious impacts 
    on performance
  - stalls happen when one instruction must wait for a previous
    one to completely execute
  - compiler deals with this is most cases, but branch-heavy code can cause stalls
  - branching (an if, or indirect jump from a virtual function call)
  - code iterating over a collection of arbitrary componts and invoking
    virtual functions incur a lot of branches (and branch prediction
    can't really help there)

* CPU Pipeline
  - instruction fetch
  - decode
  - scheduling
  - dispatch to execution units
  - read
  - execute
  - write back
  * Intel Core has 14 stages, AMD bulldozer 16-19, Pentium 4 had 20

Pipeline stall is when a large part of this pipeline is empty.

* Wait State - when CPU is stuck waiting for a memory access
  - random memory acccess can potentially take dozens or even hundreds
    of CPU cycles to service (2013 talk)  (like a i7, 180 cycles)
  - possibly the most serios performance problem when using modern CPUs
  - "in large AAA games, this can be the biggest bottleneck aside from
    graphics"

DRAM memory 
  - low power through capacitors, requires periodic refreshing. e.g. delay
  - organized into banks, rows, row-bank cache
    - access levels to the ram itself.
  - inconsistent latency due to bank access patterns, row refreshes
  - avoid hitting ram

SRAM
  - constant power, much faster than DRAM and power hungry
  - not suitable for modern multi-gig memorysizes
  - CPU caches uses SRAM
  - data/instructions can be prefetched so memory access latencies
    are incurred while the CPU is doing useful work
  - requires data be in contiguous packed memory wihtout indirections,
    not spread all over RAM

Data access hierarchy: registers -> L1/2/3 -> DRAM Row Banks (sequential access) -> network/filesystem

When thinking of algo/datastructure design, keep as much of data you're
working with closer to the registers, otherwise CPU in wait state.

"cache coherency / cache friendliness"

naive oop memory layout

```
                 Graphics component
                /
| game object 1|- physics component
                \
                 Logic component

                 Graphics component
                /
| game object 2|- physics component
                \
                 Logic component
```

each a dynamic memory allocation lord knows where, requiring pointer
indirection.

* eveyrone should read "what ever programmer needs to know about memory"

- also about simplifying design
- all problems in CS can be solved by another layer of indirection
  .. except for the problem of too many layers of indirection

focusing on POD helps alleviate that - removing layers of indirction.

- oop programming naturally leads to lots of indirection
  - encapsulation, abstract data types, interfaces - are all coding
    to the abstraction instead of directly manipulating data
  - can grow to be unweildy, confusing, error-prone, and lead to 
    performance problems.

- Dod removes concepts like encapsulation and interface abstraction
- abstract data types (templates) can still be used.

"clean vs flexible"

Dod can be cleaner for some defintiinos - removes complicated
abstractions lets the the programming direeclty achived a desire
result ,efficiently and without fuss

for heavy iteration, it can get in the way.

Abstractions and indriections do solve problems and allow for more 
runtime flexibility.

"many folks find OOP/DOD to be horrificlly messy"  Some systems
make more sense with OOP or DOD than others do.

Using it in a game engine
  - truth - your game is not suffering from performance poblems that
    will be solved by DOD
  - most AAA games can get by just fine w/o making use of DOD in
    core logic and game object code.
  - your problems are probalby all suboptimal D3D/OpenGL

DOD performance benefits don't kick until you get to very large games
with very large numbers of objects

Some places where it's extremely important
  - physics, all parts, but especially ray testing
  - graphics all parts, but especially particle engines, culling, batching
    - particle engines, could have hundreds of thousands of objects, and
      making an object for each is crazypants

Many parts of game engines do not really need DOD to have adequate
performances - can benefit from the extra flexibility
  - game logic (always a hairy mess of nastiness)
  - AI
  - tools (excepting online lightmap calcuation and large scale batch operations)x

Some game engines that focus entirely on DOD - entity systems
  - "Entity systems are the future of mmorpgs" (LOOKUP)
  - Artemis Entity System framework (Java, super simple design)

Entity sytems assign each compoent to a system that manages those
components
Components have no logic and are idealy PD
entity game objects are only an identifier used to associate components
together.

the code that updates the component is part of a system. internally
an array of the compnents, a mappiong for id->component, and designed to
be seperably - components should have no dependencies upon each other.

Presenter doesn't like the entity system, forces you to make all
your components in this DOD manner

A Conservative appraoch
  - data only components (no logic, e.g. virtual methods) as much as possible, but no
    explicit ban on logic components
  - each components' associated factory has an allocator, and can
    use a tightly packed contiguous pool allocator when necessary
  - allocate logic components together as possible
    - one loop for all logic
    - only logic components have an `update`, and logic components
      only used for actual logic and AI

And actually profile code, use things that'll count cache misses

Keep it simple. Don't sweat DOD vs OOP unless you have to


* Zig: Practical DoD - how the Zig self-hosted compiler uses data oriented design techniques - https://vimeo.com/649009599
* http://ithare.com/infographics-operation-costs-in-cpu-clock-cycles/ - operation costs in cpu clock cycles (ITHare).  2016, so a bit out of date, but still interesting.
* Handles are the better pointers - https://floooh.github.io/2018/06/17/handles-vs-pointers.html
