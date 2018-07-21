tests/operator/op.b:1:5: warning: unused symbol 'a'
var a = 1 + 2;
    ^
tests/operator/op.b:2:5: warning: unused symbol 'b'
var b = 1 - 2;
    ^
tests/operator/op.b:3:5: warning: unused symbol 'c'
var c = 1 * 2;
    ^
tests/operator/op.b:4:5: warning: unused symbol 'd'
var d = 1 / 2;
    ^
tests/operator/op.b:6:5: warning: unused symbol 'e'
var e = 1 | 2;
    ^
tests/operator/op.b:7:5: warning: unused symbol 'f'
var f = 1 & 2;
    ^
tests/operator/op.b:8:5: warning: unused symbol 'g'
var g = 1 ^ 2;
    ^
tests/operator/op.b:10:5: warning: unused symbol 'h'
var h = !false;
    ^
tests/operator/op.b:11:5: warning: unused symbol 'i'
var i = true || false;
    ^
tests/operator/op.b:12:5: warning: unused symbol 'j'
var j = true && false;
    ^
tests/operator/op.b:13:5: warning: unused symbol 'k'
var k = true == false;
    ^
tests/operator/op.b:14:5: warning: unused symbol 'l'
var l = true != false;
    ^
tests/operator/op.b:15:5: warning: unused symbol 'm'
var m = 0 < 1;
    ^
tests/operator/op.b:16:5: warning: unused symbol 'n'
var n = 0 > 1;
    ^
tests/operator/op.b:17:5: warning: unused symbol 'o'
var o = 0 <= 1;
    ^
tests/operator/op.b:18:5: warning: unused symbol 'p'
var p = 0 >= 1;
    ^
tests/operator/op.b:20:5: warning: unused symbol 'q'
var q = 2 >> 1;
    ^
tests/operator/op.b:21:5: warning: unused symbol 'r'
var r = 1 << 2;
    ^
tests/operator/op.b:23:5: warning: unused symbol 's'
var s = false ? 1 : 2;
    ^
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>

typedef void Void;
typedef bool Bool;
typedef ssize_t Int;
typedef size_t UInt;
typedef int8_t Int8;
typedef uint8_t UInt8;
typedef int16_t Int16;
typedef uint16_t UInt16;
typedef int32_t Int32;
typedef uint32_t UInt32;
typedef int64_t Int64;
typedef uint64_t UInt64;



#line 1 "tests/operator/op.b"
UInt a = ((1) + (2));
#line 2 "tests/operator/op.b"
UInt b = ((1) - (2));
#line 3 "tests/operator/op.b"
UInt c = ((1) * (2));
#line 4 "tests/operator/op.b"
UInt d = ((1) / (2));
#line 6 "tests/operator/op.b"
UInt e = ((1) | (2));
#line 7 "tests/operator/op.b"
UInt f = ((1) & (2));
#line 8 "tests/operator/op.b"
UInt g = ((1) ^ (2));
#line 10 "tests/operator/op.b"
Bool h = (!(false));
#line 11 "tests/operator/op.b"
Bool i = ((true) || (false));
#line 12 "tests/operator/op.b"
Bool j = ((true) && (false));
#line 13 "tests/operator/op.b"
Bool k = ((true) == (false));
#line 14 "tests/operator/op.b"
Bool l = ((true) != (false));
#line 15 "tests/operator/op.b"
Bool m = ((0) < (1));
#line 16 "tests/operator/op.b"
Bool n = ((0) > (1));
#line 17 "tests/operator/op.b"
Bool o = ((0) <= (1));
#line 18 "tests/operator/op.b"
Bool p = ((0) >= (1));
#line 20 "tests/operator/op.b"
UInt q = ((2) >> (1));
#line 21 "tests/operator/op.b"
UInt r = ((1) << (2));
#line 23 "tests/operator/op.b"
UInt s = ((false) ? (1) : (2));

