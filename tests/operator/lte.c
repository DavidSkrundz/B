tests/operator/lte.b:1:5: warning: unused symbol 'a'
var a = 3 <= 2;
    ^
tests/operator/lte.b:2:5: warning: unused symbol 'b'
var b = 2 <= 2;
    ^
tests/operator/lte.b:3:5: warning: unused symbol 'c'
var c = 1 <= 2;
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



#line 1 "tests/operator/lte.b"
Bool a = ((3) <= (2));
#line 2 "tests/operator/lte.b"
Bool b = ((2) <= (2));
#line 3 "tests/operator/lte.b"
Bool c = ((1) <= (2));

