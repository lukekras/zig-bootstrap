const std = @import("std");
const builtin = @import("builtin");
const expect = std.testing.expect;

test "truncate u0 to larger integer allowed and has comptime known result" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    var x: u0 = 0;
    const y = @truncate(u8, x);
    comptime try expect(y == 0);
}

test "truncate.u0.literal" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    var z = @truncate(u0, 0);
    try expect(z == 0);
}

test "truncate.u0.const" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    const c0: usize = 0;
    var z = @truncate(u0, c0);
    try expect(z == 0);
}

test "truncate.u0.var" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    var d: u8 = 2;
    var z = @truncate(u0, d);
    try expect(z == 0);
}

test "truncate i0 to larger integer allowed and has comptime known result" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    var x: i0 = 0;
    const y = @truncate(i8, x);
    comptime try expect(y == 0);
}

test "truncate.i0.literal" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    var z = @truncate(i0, 0);
    try expect(z == 0);
}

test "truncate.i0.const" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    const c0: isize = 0;
    var z = @truncate(i0, c0);
    try expect(z == 0);
}

test "truncate.i0.var" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    var d: i8 = 2;
    var z = @truncate(i0, d);
    try expect(z == 0);
}

test "truncate on comptime integer" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    var x = @truncate(u16, 9999);
    try expect(x == 9999);
    var y = @truncate(u16, -21555);
    try expect(y == 0xabcd);
    var z = @truncate(i16, -65537);
    try expect(z == -1);
    var w = @truncate(u1, 1 << 100);
    try expect(w == 0);
}

test "truncate on vectors" {
    if (builtin.zig_backend != .stage1) return error.SkipZigTest;

    const S = struct {
        fn doTheTest() !void {
            var v1: @Vector(4, u16) = .{ 0xaabb, 0xccdd, 0xeeff, 0x1122 };
            var v2 = @truncate(u8, v1);
            try expect(std.mem.eql(u8, &@as([4]u8, v2), &[4]u8{ 0xbb, 0xdd, 0xff, 0x22 }));
        }
    };
    try S.doTheTest();
}
