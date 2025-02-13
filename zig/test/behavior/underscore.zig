const std = @import("std");
const builtin = @import("builtin");
const expect = std.testing.expect;

test "ignore lval with underscore" {
    _ = false;
}

test "ignore lval with underscore (while loop)" {
    if (builtin.zig_backend == .stage2_x86_64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    while (optionalReturnError()) |_| {
        while (optionalReturnError()) |_| {
            break;
        } else |_| {}
        break;
    } else |_| {}
}

fn optionalReturnError() !?u32 {
    return error.optionalReturnError;
}
