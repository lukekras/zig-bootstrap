const builtin = @import("builtin");

test "casting integer address to function pointer" {
    if (builtin.zig_backend == .stage1) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_llvm and builtin.cpu.arch == .aarch64) return error.SkipZigTest; // TODO
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    addressToFunction();
    comptime addressToFunction();
}

fn addressToFunction() void {
    var addr: usize = 0xdeadbeef;
    _ = @intToPtr(*const fn () void, addr);
}

test "mutate through ptr initialized with constant intToPtr value" {
    if (builtin.zig_backend == .stage2_x86_64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;

    forceCompilerAnalyzeBranchHardCodedPtrDereference(false);
}

fn forceCompilerAnalyzeBranchHardCodedPtrDereference(x: bool) void {
    const hardCodedP = @intToPtr(*volatile u8, 0xdeadbeef);
    if (x) {
        hardCodedP.* = hardCodedP.* | 10;
    } else {
        return;
    }
}
