tests/struct/struct1.b:1:8: warning: unused symbol 'MyStruct'
struct MyStruct {};
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


typedef struct MyStruct MyStruct;

#line 1 "tests/struct/struct1.b"
struct MyStruct {
};

