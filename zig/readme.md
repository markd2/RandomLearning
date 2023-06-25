# Take off every "ZIG" for great justice!

* https://ziglang.org/
* when installing, brew install zig --HEAD failed with an error: _No head is defined for zig_.  Looks like that's just broken.  Going with the latest tag from homebrew.
   - also exists https://ziglang.org/download/
   - if get _“zig” can’t be opened because Apple cannot check it for malicious software._, then find it in the Finder, rat-click and do "open" and okay the security prompt it gives you
* https://github.com/ratfactor/ziglings - learn by fixing broken programs.
  - `zig build` to run
  - run a single exercise with `zig build -Dn=5`, or `zig build -Dn=5 start` to begin at a particular one
  - or `zig run exercises/001_hello.zig`


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
  - e.g. `u` for utf-8 character, `s` for utf-8 string
  - `c` for ascii character

* arrays
  * basics
```zig
var splunge: [4]u32 = [4]u32{ 23, 42, 420, 666 };
  can use inference
var splunge: [_]u32{ 23, 42, 420, 666 };
splunge.len
const foot = splunge[1]; // 42
splunge[0] = 123;
```
  * ++ to concatenate (at compile time)
```zig
const oop = [_]u8{ 1, 2 };
const ack = [_]u8{ 42, 666 };
const oopack = a ++ b;
```

  * `**` to repeat an array (at compile time)
```zig
const d = [_]u8{ 1, 2, 3 } ** 3; // 1,2,3,1,2,3,1,2,3
```

* comptime
  - work done at compile time (like array `++` and `**`)

* for loop (intro)
  - `for (<item array>) | item | { ... work with item }`
  - can also get the index - supply a second condition and a second capture value
  - `for (items, 0..) | item, index | { ...`

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
  - open-ended range: `0..`, useful in for loops for the index
  - u13 is a 13 bit integer (!)

* if
  - usual suspects.  ==, <, >, !=
  - only `bool` values - no coercing / truthy/falsy
  - also expressions  `const blah: u8 = if (splunge) 1 else 2;`

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

* at-functions
  - not sure what these actually are yet
  - @import
  - @intCast(u32, i)

* functions
  - `fn name(arg: u8) u8 { return 23; }`
  - procedures need to have `void` return

* errors
