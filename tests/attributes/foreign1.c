tests/attributes/foreign1.b:3:5: warning: unused symbol 'c'
var c: char = (char)0;
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



#line 3 "tests/attributes/foreign1.b"
char c = (char)((0));

