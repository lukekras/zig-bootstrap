const builtin = @import("builtin");
const expect = @import("std").testing.expect;

fn add(args: anytype) i32 {
    var sum = @as(i32, 0);
    {
        comptime var i: usize = 0;
        inline while (i < args.len) : (i += 1) {
            sum += args[i];
        }
    }
    return sum;
}

test "add arbitrary args" {
    if (builtin.zig_backend != .stage1) return error.SkipZigTest; // TODO

    try expect(add(.{ @as(i32, 1), @as(i32, 2), @as(i32, 3), @as(i32, 4) }) == 10);
    try expect(add(.{@as(i32, 1234)}) == 1234);
    try expect(add(.{}) == 0);
}

fn readFirstVarArg(args: anytype) void {
    _ = args[0];
}

test "send void arg to var args" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_wasm) return error.SkipZigTest; // TODO
    if (builtin.zig_backend == .stage2_c) return error.SkipZigTest; // TODO
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest; // TODO

    readFirstVarArg(.{{}});
}

test "pass args directly" {
    if (builtin.zig_backend != .stage1) return error.SkipZigTest; // TODO

    try expect(addSomeStuff(.{ @as(i32, 1), @as(i32, 2), @as(i32, 3), @as(i32, 4) }) == 10);
    try expect(addSomeStuff(.{@as(i32, 1234)}) == 1234);
    try expect(addSomeStuff(.{}) == 0);
}

fn addSomeStuff(args: anytype) i32 {
    return add(args);
}

test "runtime parameter before var args" {
    if (builtin.zig_backend != .stage1) return error.SkipZigTest; // TODO

    try expect((try extraFn(10, .{})) == 0);
    try expect((try extraFn(10, .{false})) == 1);
    try expect((try extraFn(10, .{ false, true })) == 2);

    comptime {
        try expect((try extraFn(10, .{})) == 0);
        try expect((try extraFn(10, .{false})) == 1);
        try expect((try extraFn(10, .{ false, true })) == 2);
    }
}

fn extraFn(extra: u32, args: anytype) !usize {
    _ = extra;
    if (args.len >= 1) {
        try expect(args[0] == false);
    }
    if (args.len >= 2) {
        try expect(args[1] == true);
    }
    return args.len;
}

const foos = [_]fn (anytype) bool{
    foo1,
    foo2,
};

fn foo1(args: anytype) bool {
    _ = args;
    return true;
}
fn foo2(args: anytype) bool {
    _ = args;
    return false;
}

test "array of var args functions" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_wasm) return error.SkipZigTest; // TODO
    if (builtin.zig_backend == .stage2_c) return error.SkipZigTest; // TODO
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest; // TODO

    try expect(foos[0](.{}));
    try expect(!foos[1](.{}));
}

test "pass zero length array to var args param" {
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_wasm) return error.SkipZigTest; // TODO
    if (builtin.zig_backend == .stage2_c) return error.SkipZigTest; // TODO
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest; // TODO

    doNothingWithFirstArg(.{""});
}

fn doNothingWithFirstArg(args: anytype) void {
    _ = args[0];
}
