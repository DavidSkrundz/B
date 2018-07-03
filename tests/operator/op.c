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

