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



UInt8 a = ((UInt8)'\\');
UInt8 b = ((UInt8)'\t');
UInt8 c = ((UInt8)'\n');
UInt8 d = ((UInt8)'\'');
UInt8 e = ((UInt8)'"');
UInt8* f = ((UInt8*)"\\");
UInt8* g = ((UInt8*)"\t");
UInt8* h = ((UInt8*)"\n");
UInt8* i = ((UInt8*)"'");
UInt8* j = ((UInt8*)"\"");

