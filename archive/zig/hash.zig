const std = @import("std");

pub const Point = struct {
    x: i16,
    y: i16
};

pub fn main() !void {
    var hashy = std.StringHashMap(Point).init(std.heap.page_allocator);

    const p1 = Point{ .x = 1, .y = 1 };
    try hashy.put("bork1", p1);  // putNoClobber to not clobber existing value

    var v = try hashy.getOrPut("bork2");
    if (!v.found_existing) {
        v.value_ptr.* = Point{ .x = 2, .y = 2 };
    }

    var v2 = try hashy.getOrPut("bork2");
    if (!v2.found_existing) {
        v2.value_ptr.* = Point{ .x = 3, .y = 3 };
    }

    const oot = hashy.get("bork2");
    if (oot) |o| {
        std.debug.print("blah {} {}\n", .{ o.x, o.y });
    } else {
        std.debug.print("wah wah\n", .{});
    }

    var intHash = std.AutoHashMap(u8, void).init(std.heap.page_allocator);
    try intHash.put(2, {});
    try intHash.put(3, {});
    try intHash.put(1, {});
    try intHash.put(4, {});
    try intHash.put(1, {});
    try intHash.put(5, {});
    try intHash.put(1, {});
}
