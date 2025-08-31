# Explore Swift Performance

WWDC 2024 session 10217. https://developer.apple.com/videos/play/wwdc2024/10217

should have a good intuition for what performance different langugae features
give you. 

Like C is close to the generated machien code.  locals on the stack.
heap allocation requires an explicit call

swift not so simple. Some is due to safety.  like C scribble across memory.
Plus abstractions, like closures, and generics. those have non-trivial
implementations, with costs not as visible as explicit calls to malloc.

doesn't mean you can't develop a similar intuition.

Explore the low-level performance.

* what is performance
* low-level principles
* end with putting it together.

@1:45

What is performance.

it's a deep question. be nice to feed it to a tool and get a performance
score.  it's multi-dimnesional and situational.

usually we care be ause of some macroscopic problem - daemon drawing too
much power, or app is slow to click around in.

Macroscopic goals:
  - reduce latency
  - reduce power consumption
  - stay within memory limits

Top-down performance, make measurements with tools like instruemnts.
measure measure measure and identify hotspots.  Often fixed with
algorithmic improvements:

- better aymptotic performance
- avoiding unneccessary or redundant work

Maybe do need to focus on the microscopic (bottom-up) costs

- why are we spending so long in this function
- why does this do an allocation, and what can we do aboot it?

going further requires understanding how your code is actually running.

more bototm-up approacho.

seem to be dominated by four considerations:
  - function calls (a lot of them)
  - memory layout - wasting time or memory b/c of how our data is represented
  - memory allocation - spending too much time allocating memory
  - value copying - spending a lot of time unnecessarily copying and destorying 
   values

Most featues in swift have implications for one or more of these costs.

Before getting in to all that, one last consideration first.  Compiler
optimization.  Swift comes with a fairly powerful optimizer. Things you
never see as performance issues b/c compiler elimates them

There are limits. the way you write code c an have an impact on what
the otimizer can do.  I'll also talk about optimization potential.

- optimizations can only do so much
- what optimizatiosn are possible
- what blocks those optimizations?

Trust the optimizer (but verify)

Monitor your performance
  - automated benchmarks
  - regular profiling

when identiy hotspots in top-down, figure out how to measure and automate
measurement.

Catch regressions, no matter where they came from.

@4:35 - dig in to those four lower-level principles.

  - function calls
  - memory layout
  - memory allocation
  - value copying

Function calls.

`URLSession.shared.data(for: request)`

There are four costs related to function calls:

- put the arguments in the right places
- resolve the address of the function
- allocate space for the function's local state
- optimization restrictions.  A call might inhibit optimzation in the
  caller, and in the function it calls.

Argument passing

Two levels to this cost. we need to put arguments into the right place 
(e.g. mov x2, x24; mov x0, x1).  These costs are usually hidden by 
register renaming.

at a higher level, though the compiler might have to add

like the URLSession.shared might need to be retained defensively by
the caller, and the request might need to be copied in the callee,
to match the ownership conventions. This can show up in instruments
as extra retains and releases on one side o the caller or the other

Function resolution and Optimization Impact

Both come down to the same issue. Do we know at compile time exactly
which function we're calling?
  - if so, can say the call uses _static_ dispatch. (a.k.a. direct
dispatch).  

- call always goes to a specific function definition
- compiler can inline, specialie, etc, if it can see that definition.

For polymorphism, and other powerful tools for abstraction. 
use dynamic or vitual dispatch

- call can go to different function definitions
- compiler must make conservative assumptions about the call

in swift, only specific kinds of calls use dynamic dispatch
  - calls to opaque function values
  - calls to overridable class methods
  - calls to protocol requirements
  - calls to objective-C or virtual C++ methods

everything else is static

can tell by looking at declarations.

for example

```
func updateAll(models: [any DataModel], from source: DataSource) {
    for model in models {
        model.update(from: source)
    }
}
```

a call to updte on the protocol type.  what kind of call this is depends
on where the method is declared.

if declared on the main body of a protocol, it's a protocol requirement
and so uses dynamic dispatch:

```
protocol DataModel {
    func update(from source: DataSource)
}
```

If it's declared in a protocol extension, the call uses static dispatch

```
extension DataModel {
    func update(from source: DataSource) {
        self.update(fro: source, quickly: true)
    }
}
```

very important difference, both semantically, and for performance.

the last is allocating memory for local storage

To run the updateAll needs some memory.  Because it's an ordinary synchronous
function, so it gets that memory from the "C stack". (done by subtracting
from the stack pointer)

If you compile this, you'll get code at the tstart and the end of the
function that manipulates the stack pointer

```
_$s4main9updateAll6models4frommySayAA9DtaModel_pG_AA0F6SourceCtF:
sub sp, sp, #208
stp x29, x30, [sp, #192]
...
ldp x29, x30, [sp, #192]
add sp, sp, #208
ret
```

@7:30 - example

The callframe has a layout like a C struct. ideally all of the storage needed
by the function is included

```
// sizeof(CallFrame) == 208
struct CallFrame {
    Array<AnyDataModel> models;
    DataSource source;
    AnyDataModel model;
    ArrayIterator iterator;
    ...
    void *savedX29;
    void *savedX30;
};
```

the compiler is always going to emit that subtract. it has to, to save
critical things like the return address. Subtractign a larger constant
doesn't take any longer.  allocatnig as part of the call frame is as close
as we can get to Free

Ties in nicely with the next principle

Memory Allocation

Three kinds of memory:

* Global
* Stack
* Heap

to the computer, they all come from the same RAM, but allocating them 
comes with different patterns,and that's significant to the OS, which
makes it significant for perfomrance.

Global Memory
 
- Allocated and initialized during program load
- almost free
- only usable for a fixed amount of memory that will never be freed
- used for
  - lets and vars declared at global scope
  - static stored properties

Stack Memory

- Allocated and freed by adjusting the C stack pointer
- Almost free
- Only usable for memory that does not need to outlive current scope
  - local lets and vars
  - parameters
  - other temporary values

call frames . only works in certain pattersn. memory has to be scoped.
Where we can guarantee there will be no more uses of that memory.
Meshes will with the typical local variable.

Heap Memory

Very flexible. You can allocate and free it at arbitrary times.

substantially more expensive because of the flexibility.

Used for
  - obvious things like Class and Actor instances
  - also used for some features whenever we can't prove a scope restriction
    is OK, don't have strong enough static lifetime restrictions

Reference counting

Heap memory often has shared ownership, multiple independent references
to the same memroy. We manage those with reference counting.

retain - incremet | releease - decrement

How swift uses that to store stuff, called "Memory Layout"

when we talk about _values_, talking about a high-level concept, irrespective
of what's store where in memory.

```
var array = [1.0, 2.0]
```

like this initialization, might say the value of this array is an array of two
doubles.

(it's common to refer to the in-memeory jazz as values too, but JMcC will
use the term "representation")

When looking in memory, though, 

```
array ... <ref> -> ContiguousArrayStorage
                     capacity: 2
                     size: 2
                     element #0: 1.0
                     element #1: 2.0
```

There's also the "inline representation", what you get wihtout following
any pointers

```
array ... <ref>
```

The MemoryLayout in the standard library just measures the inline
representation

```
MemoryLayout.size(ofValue: array) == 8  // single 64-bit pointer
```


Value Context

every value in swift is part of some containing context

- a local scope (local variables, intermediate results of expressions)
- an instance context (non-static stored properties)
- a global context (global variables, static stored properties
- dynamic context (bufferes managed by Array and Dictionary)

Every value also has a static type.  The value's type dictates how the
value is represented in memory, including its inline representation

The value's context dictates whre the memory comes from to hold that representation

```
func makeArray() {
    var array = [1.0, 2.0]
}
```

our array is a local variable. It's an array value Array<Double> contained
by a local scope, and so are placed in the call frame

```
struct CallFrame {
    ...
    Array<Double> array;  (8 byte ref to something)
    ...
};
```

What *is* the inline representation of an array of double?

```
public struct Array<Element> {
    var _buffer: __ContiguousArrayStorageBase
}

internal class __ContiguousArrayStorageBase { ... }
```

array is a st ruct, and the inline representation is its stored properties.
array has a single stored property, a class referene, thats a poitner
to a object. So our callframe just stores that pointer.


```
struct CallFrame {
    ...
    __ContiguousArrayStorageBase *array;
    ...
};
```

Inline verses out-of-line storage

Structs, tuples, and enumes use inline storage
  - inline representation includes the inline representations of all stored
    properties

Classes and actors use out-of-line storage
  - inline representation is just a pointer to an object
  - stored properates are contained by that object.

Value Copying

basic concept in swift is _ownership_ - the responsibility for managing
that value's representation

the inline representation of an array is a pointer to a buffer.
And uses reference counting. The buffer is being retained by the
inline representation of the array.

invariant - the underlying buffer has been retained when it is put
into the container. The container is responsible for balancing that
retain with a release.

So like

```
func makeArray() {
    var array = [1.0, 2.0]
}
```

The buffer will be released when the variable goes out of scope.

key part of memory safety:

Using a value can:
  - consume it
  - mutate it
  - borrow it

consumng value is taking owernshiop of the representation
  - assigning a value into storage
  - passing a value to a `consuming` parameter

So in the prior sample, the assignment transfers the initial value to
the variable.

Sometimes we can do this without any copies.  An initializing expression
naturally produces a new consumable value.

if we initialize a second value

```
var array = [1.0, 2.0]
var array2 = array
```

we need to transfer owenership of a value into array2 but
`var array2 = array` does not produce a new consumable value, just
refers to an existing variable.  and we can't just steal it, because
there may be more uses of it.

So need to copy the value of the old variable, and because it's an array,
copying it means retaining its buffer.

This is something that is frequently optimized.  If this is really the
last use of `array`, is value can transferred here without the overhead
of an additional copy and retain

can also explicitly consume ownership

```
var array = [1.0, 2.0]
var array2 = consume array
```

@16:46

Mutating Values

Temporarily takes ownership of a mutable variable
  - passing storage to an inout parameter
  - mutating a stored property of a struct (recursively)

difference from consuming - is still caller expects owenship by
the timethe work is done.

```
func makeArray() {
    var array = [1.0, 2.0]
    array.append(3.0)
}
```

ownership of the current value in `array` is transferred to the append method.
then it transfers ownership of a new value back to the variable.

This maintains the invariant that the variable has ownership of its value.


Borrowing

Asserts nothing else has ownership of the value that could consume or mutate i
  - calling a normal method on a value or  class reference
  - passign a value to a normal or `borrowing` parameter
  - reading the value of a property

all you care about is nobody is changing or detroying that value 

passing an argument is one of the most common situations

```
func makeArray() {
    var	array =	[1.0, 2.0]
    print(array) // borrows array
}
```

that should just work. but there are some situations where the compiler
must prove there are no simultaneous mutations of the array, and so
it can defensively copy arguments. above example, should be able to do
that reliably

```
func makeArray() {
    object.array = [1.0, 2.0]
    print(object.array)  // compiler struggles to reason about other refern4eces to obejct
}
```

like this^^ where the storage is in a class property, hard to prove the property
isn't modified at the same time, so it may need to add a defensive copy.

area where swift is evolving improbvemnts - to the optimizer, and new
langauge feature to avoid copies

Copying a value means copying the inline representation, which gives a new
inline representation with new ownership

copying a class value means copying the reference. 
copying a struct means recursively copying all the struct properties

inline storage:
  - avoids heap allocations
  - great for small types
  - copies get more expensive the more properties you have
    - "can become a significant drag on performance"

no hard-and-fast rules for optimal performance

Cost of copying two structs come in two parts.

```
struct Person {
   var name: String
   var address: String
   var relationships: [Relationship]
   var birthday: Date
}
```

first, when copying, not juts coying the bits.

The top three are represented by a small struct around object references.
and will need to be reteained when copying the enclosing struct.

So if turned into a class, a copy would be a retain, and as a struct,
will be 3 retains.

And each copy will need its own storage.  if this used out-of-band storage,
boith of those would be reduced. 

still, no hard-and-fast rule.


out-of-line mutable storage naturally has reference semantics
  - mutations to one value are visible in copies of it
  - challenging in multi-threaded environments

Struct behave this way, but always use in-line storage.

can get both by wrapping class referecne with a stuct.
In mutations, copy the object if the reference isn't unique. (COW)

Foundation does this for founation data structures.

@20:59 putting it together.

- dynamically sized types
- async functions
- closures
- generics

in C, structs are fixed size, but swift can be determined at runtime.
comes up in two cases.

First many value types reserve the right to change their size in future
OS updates.  like Foundation's URL.  Everything about their layout
has to be treated as an unknown at compile time.

second, a type parameter for generics can be replaced by any type.

```
strut GenericConnection<T> {
    var username: String
    var address: T // ?? bytes
    var options: [String: String]
}
```

have to treat layout as unknown.

exception is if the type is contrainted to a class, then it turns
in to a reference

```
strut GenericConnection<T> where T: AnyObject {
    var	username: String
    var	address: T // ?? bytes
    var	options: [String: String]
}
```

can lead to more efficient code even when generic substitution doesn't
kick in, _if_ you're ableto accept that constraint

Dynamically sized types in variabley-sized containers

how does sit work when don't kow the static represenation of the tpe.

Depends on container.

We can defer layot at runtmie.

b/c layout is not tatic, the layout of connection can't be known. that's
fine.  Becomes the problem of whatever contains the connection.

The compiler knows the static layout until the first dyhamicaly sized
property. It'll ahve to calcaulate and load dynamic offsets rather
than using constants.

the call frames contain pointers to lazily-allocated memory.
which could be on the C-stack due to lifetime (another subtraction
of the size of the URL variable

async functions

"C threads are a precious resource". Holding on to a thread just to make
it block is not a good use of that resource

Designed to be able to abandon a C thread when they need to suspend
  - keep local state on a special stack
  - split functions into partial functions that run between suspensions.

```
func awaitAll(tasks: [Task<Int, Never>]) async -> [Int] {
    var results = [Int]()
    for task in tasks {
        results.append(await task.value)
    }
    return results
}
```

There's one potential suspension point. (the await task.value)

The results and task have uses across the suspension point, so they can't
be saved on the C-stack.

We talked about how sync functions allocate space on the C stack by
stack pointer games. Async functions the same thing, but they don't use
a large contiguous stack.

Async Tasks hold on to one or more slabs of memory (512 bytes in the example)
When an async function wants stack space, the task tries to use space 
in the slab, and then gives it to the function.

If most of the slab is occupied, however, then the task will malloc a new
slab, and the allocation comes out of that (leaving unused space in the
first slab)

Dealloction hands memory back to the task, and gets marked as unused.

because this is only used by a single task, and has stack discipline,
it's typically signifiantly faster than malloc.

overall performance profile is similar to synchronous functions, just with
a bit higher overhead.

To run, an async function needs to be split into partial functions
that span the gaps of the potential suspension point.

because there's one await, we get two partial functions.  First part is the
entry into the function

```
func awaitAll(tasks: [Task<Int, Never>]) async -> [Int] {
    var results = [Int]()
    for task in tasks {
```

if the array is empty, it'll just refer to the async caller.
otherwise it pulls the first task and awaits it.

The other function picks up after the await (

```
func awaitAll(tasks: [Task<Int, Never>]) async -> [Int] {
        results.append(await task.value)
    }
    // (with a branch up to the await)
    return results
}
```

where it adds the output of the task to the output array

if no tasks , it returns to the async caller

The key idea there is only one partial function on the C-stack.

We enter one partial function and run like an ordinary C function until
the next potential suspension point.  If it needs some local state that
doesn't need to cross the suspension point, it can put that into its
C callframe. 

The partial function tailcalls the next partial function.  Its frame disappears,
and then the next frame takes its place.  The *that* function runs until
it hits a potential suspension point

if a task needs to suspend, it returns normally to the C stack, which
will return it to the Swift runtime

```
Stack top
[Swift runtime]
[(push partial function #X)]
[unused]
```

and the thread can be immediately reused for something else.

Closures

Up to now, it's been function declarations, how do closures work?

closures are passed around as values of function types

```
func sumTwice(f: () -> Int) -> Int {
    return f() + f()
}
```

non-escaping function.

function values in swift are always a pair of a function pointer and a context pointer

```
Int sumTwice(Int (*fFunction)(void *), void *fContext) {
    return fFunction(fContext) + fFunction(fContext);
}
```

closure values that capture from the enclosing scope

```
func puzzle(n: Int) -> Int {
     return sumTwice { n + 1 }  // n is captured
}
```

package the values into the contents.  what it does depends on the kind
of function value it has to produce.

in this case, it's a non-@escaping function, we know the function will not
be used after the call completes.

That means does not need to be memory managed, and can be allocated with
a scoped allocation.

The context will be a simple structure with the captured value.
and it can be allocated on the stack, and passed to SumTWice

```
func sumTwice(f: () -> Int) -> Int {
    return f() + f()
}

func puzzle(n: Int) -> Int {
     return sumTwice { n + 1 }  // n is captured
}

struct puzle_context {
    Int n;
};

Int puzzle(Int n) {
    struct puzzle_context context = { n };
    retrun sumTwice(&puzzle_closure, &context);
}

Int puzzle_closure(void * _context) {
    struct puzzle_context *context = (struct puzzle_context *) _context;
    return _context->n + 1;
}
```

and in the closure, we know the type of the context, and can just pull the
value out.

This is different from escaping closures.

```
func sumTwice(f: @escaping () -> Int) -> Int {
    return f() + f()
}
```

we no longer know the closure used in the duration of the caller.

so we know the context needs to be heap allocated and maintained with
retains and releases.

the context behaves like an instance of an anymous swift class.


```
class puzzle_context {
    let n: Int
}
```

When you refer to a local var in a closure, you capture it by reference.

```
func puzzle(n: Int) {
    var addend = 0
    return sumTwice {
        addend += 1       // captures addend by reference
        return n + addend // and n by value
    }
}
```

lets you make chagnes to variable oserved in original scope.

If we don't cpature escaping, it won't change the lifetime of hte variable,
as a result, can capture pointers to variable's allocation.

but if it's captured by escaping,  the lifetime of the var lasts as long
as the closure.  the var also needs to be heap allocated

```
class Box<T> {
   let value: T  // pity the fool
}

class puzzle_context {
    let n: Int
    let addend: Box<Int>
}
```

Generics

This function is generic over its data model

```
protocol DataModel {
    func update(from source: DataSource)
}

// model type is constrained to a protocol
func updateAll<Model: DataModel>(models: [Model], from source: DataSource) {
    for model in models {
        model.update(from: source) // call uses protocol requirement
    }
}
```

we talked about how layout is statically unknown, and how handled in
different containers.

But not talked about protocol constraints.

swift protocols represented by a table of function pointers

```
protocol DataModel {
    func update(from source: DataSource);
}

struct DataModelWitnessTable {
    ConformanceDescriptor *identity;
    void (*update)(DataSoure source, TypeMetadata *Self);
};
```

any time we haev a protocol constraint, we're passing around an appropriate
table.

```
func updateAll<Model: DataModel>(models: [Model], from source: DataSource) {

void updateAll(Array<Model> models,
               DataSource source,
               TypeMetadata *Model,
               DataModelWitnessTable *Model_is_DataModel);
```

in a generic function, the type and witness tables become hidden extra
parameters.  It all comes straightforwardly from the swift signature.

it can do this because all elements of the array conform to the exact
same type, which is known at compile(?) time.

When working with values of protocol type, it worsk differently and
more flexible

```
protcol DataModel {
    func update(from source: DataSource)
}

func updateAll(models: [any DataModel], from source: DataSource)
```

each value in the array can be a different type of data model. (vs the
generic example where it's uniform across the entire array)

has tradeoffs how efficiently will run,


AnyDataModel looks like this in C

```
struct AnyDataModel {
    OpaqueValueStorage value;
    TypeMetadata *valueType;
    DataModelWitnessTable *value_is_DataModel;
}
```

storage for the value, and fields to record the value's type, and any
conformances it has.

But this has to be a fixed-sized type, regardless of valueType.  Its representaiton
can't change sizes to support different types.

no matter how lorge we make this, someone can come up with a superchonker.

Swift uses an arbitrary buffer size of three pointers:

```
struct OpaqueValueStorage {
    void *storage[3]; // heuristically chosen to fit most common types
};
```

(which is a shame, because rectangles could fit if there's 4...)

If the value can fit int that buffer, it'll fit.  

otherwise it'l allocate memory and store that value.


to recap

```
// takes a homogeneous array of data models
// efficienty packaged into an array
// type information passed one into the function
func updateAll<Model: DataModel>(models: [Model], from source: DataSource) {
    for model in models {
        model.update(from: source) // call uses protocol requirement
    }
}

// takes a heterogeneous array of data model
// each element of the array has its own dynamic type
// values won't be densly packed in the array
func updateAll(models: [any DataModel], from source: DataSource) {
    for model in models {
        model.update(from: source) // call uses protocol requirement
    }
}
```

the generic function can also be specialized if the caller knows what type
it's being called with.

```
func updateAll<Model: DataModel>(models: [Model], from source: DataSource) {
    for model in models {
        model.update(from: source) // call uses protocol requirement
    }
}

var oogie: [SomeDataModel]
upateAll(models: oogie, from: source)
```

the optimizer can inline the call, or produce a special version of the function
that works with the implemetnion bny statically dispatching

This removes abstraction costs.

The [any DataModel] one takes a heterogenous array of data moels. 
This is more flexible.

optimizing is much more difficult in practice, can't really devirtualize it.
Will be getting a lot less help from the compiler.

everything with a cost -it's a cost. sometimes cost are good for the 
good you get out of it.

