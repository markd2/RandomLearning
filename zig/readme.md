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


