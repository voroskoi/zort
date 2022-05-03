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
    context: anytype,
    lessThan: fn (@TypeOf(context), a: T, b: T) bool,
) void {
    if (items.len < 2) return;
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
    lessThan: fn (context: @TypeOf(context), a: T, b: T) bool,
) void {
    const key: T = undefined;
    const pta: T = undefined;
    const end: T = undefined;

    var i: usize = offset;
    while (i < items.len) : (i += 1) {
        pta = items + i;
        end = items + i;
    }
}
