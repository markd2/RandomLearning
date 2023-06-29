# Take off every "ZIG" for great justice!

* https://ziglang.org/
* "Rust is trying to be a better C++, Zig is trying to be a better C"
* when installing, brew install zig --HEAD failed with an error: _No head is defined for zig_.  Looks like that's just broken.  Going with the latest tag from homebrew.
   - also exists https://ziglang.org/download/
   - if get _“zig” can’t be opened because Apple cannot check it for malicious software._, then find it in the Finder, rat-click and do "open" and okay the security prompt it gives you
* https://github.com/ratfactor/ziglings - learn by fixing broken programs.
  - `zig build` to run
  - run a single exercise with `zig build -Dn=5`, or `zig build -Dn=5 start` to begin at a particular one
  - or `zig run exercises/001_hello.zig`
* https://github.com/DanB91/Zig-Playdate-Template

### Random notes

* importing
```zig
const std = @import("std");
```

* main
```zig
pub fn main() void {
    std.debug.print("splunge\n", .{});
}
```

* constants and variables. u for unsigned, i for signed integer
```zig
const blah: u8 = 20;
var greeble: u16 = 65531;
```

* printing - takes two parameters. First is a string with {} placeholders. Second is an _anonymous list literal_ with the values to be printed.
```zig
    std.debug.print("{} {} {}\n", .{ n, pi, negative_eleven });
```
  - can put format specifiers in the braces
  - e.g. `u` for utf-8 character, `s` for utf-8 string, `b` for binary
  - `c` for ascii character
  - {x:0>6} - x for lower-case hex, : separator, 0 padding character, alignment > (right), width (use padding to force width)

* arrays
  - basics
```zig
var splunge: [4]u32 = [4]u32{ 23, 42, 420, 666 };
  can use inference
var splunge: [_]u32{ 23, 42, 420, 666 };
splunge.len
const foot = splunge[1]; // 42
splunge[0] = 123;
```
  - `++` to concatenate (at compile time)
```zig
const oop = [_]u8{ 1, 2 };
const ack = [_]u8{ 42, 666 };
const oopack = a ++ b;
```

  - `**` to repeat an array (at compile time)
```zig
const d = [_]u8{ 1, 2, 3 } ** 3; // 1,2,3,1,2,3,1,2,3
```

* slice
  - essentially a pointer plus length
  - e.g. `const foo = digits[0..1];`
  - or any range.  `const all = digits[0..];`
  - type is, say for a `[23]u8`, its slice type is `[]u8`.
  - can be const slice `var blah: []const u8 = "oopack"[0..3];`
  - can make pointers to multiple items without a slice (so like a pointer without length).  Keeping track of the valid length is an exercise for the ~reader~ programmer.
```zig
var blah: [_]u8 = [_]u8{ 1, 2, 3, 4 };
var slice: []u8 = blah[0..];
var pointer: [*]u8 = &foo;
```

* comptime
  - work done at compile time (like array `++` and `**`)

* for loop (intro)
  - `for (<item array>) | item | { ... work with item }`
  - can also get the index - supply a second condition and a second capture value
  - `for (items, 0..) | item, index | { ...`
  - can capture as a pointer `for (&aliens) |*alien| {`

* strings
  - arrays of bytes
  - `const greeble = "Greeble";`
  - single characters as `'H'`
  - multi-line strings, put `\\` at the beginning of the line
```zig
const fnord_bork =
    \\Oop Ack
    \\Greeble Bork
;
```

* special types / values
  - `usize` - for sizes, like size_t
  - `undefined` - when declaring memory, without putting anything in to it
    - in debug builds, writes 10101010 its (0xAA) to be eaiser to spot.
  - open-ended range: `0..`, useful in for loops for the index
  - u13 is a 13 bit integer (!)
  - 0o777 for octal
  - 0b100101 for binary
  - 'Q' utf-8 code point literal
  - 12_345_678 for readability
  - 0xAB_AD_0B_0E as well
  - f32 for float
  - 1.2e+3 / 100_000.42 / -5.0e+5
  - for hex, can't use e, so use p: f16 = 0x2A.f7p+3;
  - Zig does not perform unsafe type coercions
  - floating point type for C ABIs: c_longdouble
  - `unreachable`
  - `type`
  - numeric literals are `comptime_int` or `comptime_float`
    - they get inlined at usage points
    - for vars with const values, need to explicitly provide a type, so 
      the compiler knows how many bytes to use
  - `anytype` - tell the compiler to infer the actual type at compile time.
  - underscore useful for "using" a value by ignoring it

* if
  - usual suspects.  ==, <, >, !=
  - only `bool` values - no coercing / truthy/falsy
  - also expressions  `const blah: u8 = if (splunge) 1 else 2;`
  - `unreachable` for branches - reaching it is an error
    - "terminated immediately"

* while
  - usual suspects, including `break` and `continue`
```zig
while (condition) {
    condition = false;
}
```
  - can have an optional 'continue expression' at the end or a explicit `continue`
    - `while (condition) : (continue expression) { ... }`
```zig
var blah = 2;
while (blah < 10) : (blah += 3) {
     do something
}
```

* at-functions / builtins
  - not sure what these actually are yet
  - @import - pull in inter faces
    - e.g. const std = @import("std")
    - std is a struct
  - @intCast(u32, i) - cast types
  - @intFromEnum(x) - convert an enum case to its corresponding number
  - intrinsic to the langauge
  - over a hundred of them =:-O
    - https://ziglang.org/documentation/master/#Builtin-Functions
    - can provide functionalkity that is only possible with help from
      the compiler (such as type introspection)
  - "comptime" parameters need to be known at compile time.
  - @addWithOverflow - addition, returns a tuple with the result and a possible overflow bit.
    - dig into a tuple with [0], [1], etc
  - @bitReverse(integer: anytype) T
    - value to reverse.
  - math functions @sqrt / @exp / @sin / @log / @cos / @floor etc
  - type casting @as / @errorFromInt / @floatFromInt / @ptrFromInt / @intFromPtr / @intFromEnum
  - some esoterica like @call, @compileLog, @embedFile (cool!), @src
  - @This - returns innermost struct/enum/union that a function call is inside
    - capital b/c it works on a type
  - @typeInfo - returns information about any type in a TypeInfo union
  - @TypeOf - returns type common to all input parameters. (c.f. "peer type resolution")
  - @compileError - stop compilation with an error
  - @intCast

* functions
  - `fn name(arg: u8) u8 { return 23; }`
  - procedures need to have `void` return
  - return `!void` - infer error types on the return
    - https://ziglang.org/documentation/master/#Inferred-Error-Sets
    - inferred error sets interact badly with function pointers and recursion
    - also makes the function generic

* errors
  - interesting - error traces. https://ziglang.org/documentation/master/#Error-Return-Traces
  - errors are values. Named so can identify things
  - created in "error sets", collections of named errors
```zig
const NumberError = error {
    TooBig,
    TooSmol,
    TooFour,
};
```
  - returned (along with useful work) via "error union"
    - `var text: ErrorSet!Text = getText("oop.ack")
  - can catch and use a default (which is kind of icky)
    - `blah = canFail() catch 23;`
  - generalzied form (note trailing semicolon):
```zig
canFail() catch |err| {
    if (err == SplungeError.GreebleBork) { ... }
};
```
  - idiomatic error handling
```zig
    return detectProblems(n) catch |err| {
        if (err == MyNumberError.TooSmall) {
            return 10;
        }
        return err;
    };
```
  - sugared by `try`: `try detectProblems(666);`
    - does not look like exceptions, more like swift's if-based try
    - can't ignore errors
  - if for handling errors
```zig
if (blah) |value| { // use value
} else |err| { // an error
```
  - can also do a switch on the errors
```zig
if (blah) |value| { ...
} else |err| switch(err) {
    ...
}
```

* defer
  - like swift
  - also an`errdefer`, only called if a try fails.

* switch
  - match possible values of an expression and perform a different action.  Note the commas
```zig
switch (splunge) {
    1 => doSomething(),
    2 => doSomethingElse(),
    else => {
        // freak out
        return Error.TooMuchSplunge;
    }
}
```
  - can also be used as an expression
```zig
const oopack = switch (x) {
    1 => 23,
    2 => 44,
    ...
}
```

* enums
  - like C enums - give names to numeric values
```zig
const Fruit = enum { orange, bananananaa, tomato };
const my_flute = Fruit.tomato;
```
  - can specify the storage size: `const Blah = enum(u8){ oop = 16 };
  - can extract the integer with @intFromEnum()
  - when doing a switch, don't have to write the full name. e.g.
```zig
    const class_name = switch (c.class) {
        .wizard => "Wizard",
        .thief => "Thief",
        .bard => "Bard",
        .warrior => "Warrior",
    };
```

* structs
  - define via `const Point = struct{ x: u32, y: u32, z: u32 };`
  - make via `const point = Point( .x=3, .y=16, .z=27 };`
  - can attach functions to structs (and other 'type definitions')
```zig
const Blah = struct {
    pub fn howdy() void { // print hello }
};
```
  - it's namespaced:  `Blah.howdy()`
  - if the first argument is an instance / pointer to struct, can use it as a method. Looks like no guidance on preferred this/self form?
```zig
const Splort = struct {
    pub fn a(self: Splort) void {}
    pub fn b(this: *Splort, other: u8) void {}
    pub fn c(splort: *const Splort) void {}
};
then can call like
var sport = Splort()
splort.a()
splort.b(23)
splort.c()
```
  - enums can have methods too (cool!)

* pointers
  - C like
```zig
var blah: u8 = 5;
var splunge: *u8 = &blah;
var oop = splunge.*
```
  - variable pointers and constant pointers - `const blah: u8 = 5; &blah` is a const pointer
  - can always make a const pointer to a mutable value, but can't make var pointer to a constant value.  (preventing coercion to a mutable type)
    - `const b: *const u8 = &a;`
  - like C, use pointers to pass by reference
```zig
fn makeFive(x: *u8) void {
    x.* = 5; // fix me!
}
```
  - for structs, use the same syntax for structs or pointers to structs(!)
```zig
var pv: *Vertex = &v1;
const blah = pv.x;
```
  -  pointer cheatsheet:
```zig
   |  u8           |  one u8                                      |
   |  *u8          |  pointer to one u8                           |
   |  [2]u8        |  two u8s                                     |
   |  [*]u8        |  pointer to unknown number of u8s            |
   |  [*]const u8  |  pointer to unknown number of immutable u8s  |
   |  *[2]u8       |  pointer to an array of 2 u8s                |
   |  *const [2]u8 |  pointer to an immutable array of 2 u8s      |
   |  []u8         |  slice of u8s                                |
   |  []const u8   |  slice of immutable u8s                      |
``` 

* Optionals
  - `var splunge: ?u32 = 10;`
    - splunge can hold a value or null
  - for null pointer values, use ?* type (
```zig
    const blah: ?*Vertex = null
```
  - Swift's `??` operator is called `orelse`
    - `var blah = splunge orelse 23;`
  - `.?` is sugar over that + unreachable
    - `const blah = splunge.?`
    - note how it parallels the pointer dereference syntax style
  - there's four ways of expressing "no value"
    - undefined - not a value
    - null - is a value, just "not there"
    - error
    - void - a "zero bit type" (take up no space)

* Unions
  - store different types and sizes of data at the same address (note use of commas)
```zig
const UnionThing = union {
    small: u8,
    medium: u32,
    large: u64
}
```
  - once a field becaomes active, the other fields cannot be accessed
    - so can't use this as a reinterpretation mechanism?
  - how to know what's in there?  `tagged unions` - store an enum value
    to indicate which field is active
```zig
const SplungeTag = enum{ greeble, bork, fnord };
const Splunge = union(SplungeTag) {
    greeble: u8,
    bork: u16,
    fnord: u64
};
var oinq = Splunge{ .bork = 10 };
switch (oinq) {
    .greeble => |grebl| doSomething(grebl),
    .bork => |bork| doSomething(bork),
    .fnord => |fnor| doSomething(fnor)
}
```
  - can also use inferred enum
```zig
const Foo = union(enum) {
   smol: u8,
   medium: u32,
   lorge: u64
}
```
  - optional values are "null unions" and errors are "error union tpes"
  - we can add our own `union(Tag) { value: u32, toxic_ooze: void }`
  - can coerce a union to an enum (gives the active field from the union
    as an enum.
  - can coerce an enum to a union (but only if it's a zero-bit type like void)
    - don't quite grok what this means or why it's important

* type variations list:
```
                          u8  single item
                         *u8  single-item pointer
                        []u8  slice (size known at runtime)
                       [5]u8  array of 5 u8s
                       [*]u8  many-item pointer (zero or more)
                 enum {a, b}  set of unique values a and b
                error {e, f}  set of unique error values e and f
      struct {y: u8, z: i32}  group of values y and z
 union(enum) {a: u8, b: i32}  single value either u8 or i32

     const a: u8 = 5; // immutable
       var b: u8 = 5; //   mutable

     var a: E!u8 = 5; // can be u8 or error from set E
     var b: ?u8 = 5;  // can be u8 or null
```

* expressions
  - can use for and while loops as expressions (in addition to ifs)
  - `break true;`  // or whatever the value is.
  - can also have else clauses (!)
  - `const two: u8 = while (true) break 2 else 0;`
     - notice it's not "else return 0" - the return would return from the whole
       function
  - the compiler will add an implicit void, so will most likely get an error

* labels
  - can give names to blocks by applying a label `splunge: { ... }`
  - can use break to exit from that block
```zig
outer_bloke: {
    while(true) {
        break :outer_bloke;
    }
    unreachable;
}
```
  - works with continue too
  - can also break and return a value  `break :outer_bloke 24;`

* comptime
  - explicitly request compile time evaluation
  - const comptime constants have types like comptime_int and comptime_float
  - comptime var usage `var blah = 5;` is right out, unless annotated by `comptime`
    - `comptime var blah = 5;`
  - `@compileLog("Count at compile time: ", count);` for caveman debugging during comptime, with an error at the end
  - decorate a function parameter with comptime to enforce the parameter
    is known at compile time.  `fn blah(comptime fmt: []const u8)`
    - the format string parser runs entirely at compile time
  - types are only available at comptime
    - use `anytype` placeholder to infer the actual type at compile time
    - `fn blah(thing: anytype) void { ... }`
    - can use @TypeOf(), @typeInfo(), @typeName(), @hasDecl(), and
      @hasField() to determine more about the type (zigling 70)
    - typeof and hasdecl for ducktyping
  - "decl" is a method declared in a struct (maybe more?) namespace
  - `inline for` for comptime loops
```zig
inline for( .{ u8, u16, u32, u64 }) |T| {
    print("{} ", .{ @typeInfo(T).Int.bits });
}
```
  - `inline while`, like inline for, but while-styles