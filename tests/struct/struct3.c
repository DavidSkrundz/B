tests/struct/struct3.b:13:6: warning: unused symbol 'test'
func test() {
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


typedef struct S S;
Void S_setA(S* self, UInt newA);
UInt S_getA(S* self);

#line 1 "tests/struct/struct3.b"
struct S {
	UInt a;
};
Void test(void);

#line 4 "tests/struct/struct3.b"
Void S_setA(S* self, UInt newA) {
	#line 5 "tests/struct/struct3.b"
	((self)->a) = (newA);
}

#line 8 "tests/struct/struct3.b"
UInt S_getA(S* self) {
	#line 9 "tests/struct/struct3.b"
	return ((self)->a);
}

#line 13 "tests/struct/struct3.b"
Void test(void) {
	#line 14 "tests/struct/struct3.b"
	S* s = (NULL);
	#line 15 "tests/struct/struct3.b"
	(S_setA((s), (4)));
	#line 16 "tests/struct/struct3.b"
	(S_getA((s)));
}

