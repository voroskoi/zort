//! Zig port of quadsort by VÖRÖSKŐI András <voroskoi@gmail.com>

// Copyright (C) 2014-2022 Igor van den Hoven ivdhoven@gmail.com

// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// quadsort 1.1.5.2
// https://github.com/scandum/quadsort/blob/7a250085bb46c8a5e1cb74391104f312ee2fa8e7/src/quadsort.[hc]

const std = @import("std");

pub fn quadSort(
    comptime T: anytype,
    items: []T,
    // context: anytype,
    // lessThan: fn (@TypeOf(context), a: T, b: T) bool,
) void {
    if (items.len < 2) return;

    // if (items.len < 32) {
    //     tailSwap(items, lessThan);
    // } else if (quadSwap(items, lessThan) == 0) {
    //     // XXX: missing...
    // }
}

// #define parity_merge_two(array, swap, x, y, ptl, ptr, pts, cmp)  \
// {  \
//     ptl = array + 0; ptr = array + 2; pts = swap + 0;  \
//     x = cmp(ptl, ptr) <= 0; y = !x; pts[x] = *ptr; ptr += y; pts[y] = *ptl; ptl += x; pts++;  \
//     *pts = cmp(ptl, ptr) <= 0 ? *ptl : *ptr;  \
//   \
//     ptl = array + 1; ptr = array + 3; pts = swap + 3;  \
//     x = cmp(ptl, ptr) <= 0; y = !x; pts--; pts[x] = *ptr; ptr -= x; pts[y] = *ptl; ptl -= y;  \
//     *pts = cmp(ptl, ptr)  > 0 ? *ptl : *ptr;  \
// }

// #define parity_merge_four(array, swap, x, y, ptl, ptr, pts, cmp)  \
// {  \
//     ptl = array + 0; ptr = array + 4; pts = swap;  \
//     x = cmp(ptl, ptr) <= 0; y = !x; pts[x] = *ptr; ptr += y; pts[y] = *ptl; ptl += x; pts++;  \
//     x = cmp(ptl, ptr) <= 0; y = !x; pts[x] = *ptr; ptr += y; pts[y] = *ptl; ptl += x; pts++;  \
//     x = cmp(ptl, ptr) <= 0; y = !x; pts[x] = *ptr; ptr += y; pts[y] = *ptl; ptl += x; pts++;  \
//     *pts = cmp(ptl, ptr) <= 0 ? *ptl : *ptr;  \
//   \
//     ptl = array + 3; ptr = array + 7; pts = swap + 7;  \
//     x = cmp(ptl, ptr) <= 0; y = !x; pts--; pts[x] = *ptr; ptr -= x; pts[y] = *ptl; ptl -= y;  \
//     x = cmp(ptl, ptr) <= 0; y = !x; pts--; pts[x] = *ptr; ptr -= x; pts[y] = *ptl; ptl -= y;  \
//     x = cmp(ptl, ptr) <= 0; y = !x; pts--; pts[x] = *ptr; ptr -= x; pts[y] = *ptl; ptl -= y;  \
//     *pts = cmp(ptl, ptr)  > 0 ? *ptl : *ptr;  \
// }

fn unguardedInsert(
    comptime T: anytype,
    items: []T,
    offset: usize,
    // lessThan: fn (context: @TypeOf(context), a: T, b: T) bool,
) void {
    var i: usize = offset;
    while (i < items.len) : (i += 1) {
        var pta = i;
        var end = i;

        pta -= 1;
        if (std.math.order(items[pta], items[end]).compare(.lte)) continue;

        const key = items[end];

        if (std.math.order(items[0], key).compare(.gt)) {
            var top = i;
            while (true) {
                items[end] = items[pta];
                end -= 1;
                pta -|= 1;

                top -= 1;
                if (top == 0) break;
            }
            items[end] = key;
        } else {
            while (true) {
                items[end] = items[pta];
                end -= 1;
                pta -|= 1;

                // this is a condition to break from loop, so reverse the original
                if (std.math.order(items[pta], key).compare(.lte)) break;
            }
            items[end] = key;
        }
    }
}

test "unguardedInsert" {
    {
        var array = [_]usize{ 1, 4, 8, 12, 3, 21, 18 };
        const exp = [_]usize{ 1, 3, 4, 8, 12, 18, 21 };

        // only sorts items after offset!
        unguardedInsert(usize, &array, 1);

        try std.testing.expectEqualSlices(usize, &exp, &array);
    }

    {
        var array = [_]usize{ 1, 4, 8, 12, 3, 21, 18 };
        const exp = [_]usize{ 1, 4, 8, 12, 3, 18, 21 };

        unguardedInsert(usize, &array, 5);

        try std.testing.expectEqualSlices(usize, &exp, &array);
    }

    {
        var array = [_]usize{ 1, 4, 8, 12, 3, 21, 18 };
        const exp = [_]usize{ 1, 4, 8, 12, 3, 21, 18 };

        unguardedInsert(usize, &array, 7);

        try std.testing.expectEqualSlices(usize, &exp, &array);
    }

    {
        const ARRAY_SIZE = 10_000;
        const TYPE = usize;
        const rnd = std.rand.DefaultPrng.init(@intCast(u64, std.time.milliTimestamp())).random();
        var array = try std.ArrayList(TYPE).initCapacity(std.testing.allocator, ARRAY_SIZE);
        defer array.deinit();

        var i: usize = 0;
        while (i < ARRAY_SIZE) : (i += 1) {
            const num = rnd.intRangeAtMostBiased(usize, std.math.minInt(TYPE), std.math.maxInt(TYPE));
            array.appendAssumeCapacity(num);
        }

        var reference = try array.clone();
        defer reference.deinit();

        std.sort.sort(TYPE, reference.items, {}, comptime std.sort.asc(TYPE));
        // std.debug.print("{any}\n", .{reference.items});

        unguardedInsert(TYPE, array.items, 1);
        // std.debug.print("{any}\n", .{array.items});

        try std.testing.expectEqualSlices(TYPE, reference.items, array.items);
    }
}
