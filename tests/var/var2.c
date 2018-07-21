tests/var/var2.b:1:5: warning: unused symbol 'a'
var a = '\\';
    ^
tests/var/var2.b:2:5: warning: unused symbol 'b'
var b = '\t';
    ^
tests/var/var2.b:3:5: warning: unused symbol 'c'
var c = '\n';
    ^
tests/var/var2.b:4:5: warning: unused symbol 'd'
var d = '\'';
    ^
tests/var/var2.b:5:5: warning: unused symbol 'e'
var e = '"';
    ^
tests/var/var2.b:7:5: warning: unused symbol 'f'
var f = "\\";
    ^
tests/var/var2.b:8:5: warning: unused symbol 'g'
var g = "\t";
    ^
tests/var/var2.b:9:5: warning: unused symbol 'h'
var h = "\n";
    ^
tests/var/var2.b:10:5: warning: unused symbol 'i'
var i = "'";
    ^
tests/var/var2.b:11:5: warning: unused symbol 'j'
var j = "\"";
    ^
tests/var/var2.b:12:5: warning: unused symbol 'k'
var k = "\"\n\t";
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



#line 1 "tests/var/var2.b"
UInt8 a = ((UInt8)'\\');
#line 2 "tests/var/var2.b"
UInt8 b = ((UInt8)'\t');
#line 3 "tests/var/var2.b"
UInt8 c = ((UInt8)'\n');
#line 4 "tests/var/var2.b"
UInt8 d = ((UInt8)'\'');
#line 5 "tests/var/var2.b"
UInt8 e = ((UInt8)'\"');
#line 7 "tests/var/var2.b"
UInt8* f = ((UInt8*)"\\");
#line 8 "tests/var/var2.b"
UInt8* g = ((UInt8*)"\t");
#line 9 "tests/var/var2.b"
UInt8* h = ((UInt8*)"\n");
#line 10 "tests/var/var2.b"
UInt8* i = ((UInt8*)"\'");
#line 11 "tests/var/var2.b"
UInt8* j = ((UInt8*)"\"");
#line 12 "tests/var/var2.b"
UInt8* k = ((UInt8*)"\"\n\t");

