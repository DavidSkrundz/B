tests/enum/enum1.b:6:5: warning: unused symbol 'a'
var a = ExitStatus.Success;
    ^
tests/enum/enum1.b:7:5: warning: unused symbol 'b'
var b: ExitStatus = .Failure;
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


#line 1 "tests/enum/enum1.b"
typedef enum ExitStatus {
	ExitStatus_Success,
	ExitStatus_Failure,
} ExitStatus;

#line 6 "tests/enum/enum1.b"
ExitStatus a = (ExitStatus_Success);
#line 7 "tests/enum/enum1.b"
ExitStatus b = (ExitStatus_Failure);

