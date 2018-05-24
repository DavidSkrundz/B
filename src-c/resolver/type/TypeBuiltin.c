#include "TypeBuiltin.h"

#include <stdlib.h>

#include "TypeResolve.h"

Type* TypeVoid = NULL;
Type* TypeBool = NULL;
Type* TypeInt = NULL;
Type* TypeUInt = NULL;
Type* TypeInt8 = NULL;
Type* TypeUInt8 = NULL;
Type* TypeInt16 = NULL;
Type* TypeUInt16 = NULL;
Type* TypeInt32 = NULL;
Type* TypeUInt32 = NULL;
Type* TypeInt64 = NULL;
Type* TypeUInt64 = NULL;

Type* TypeAny = NULL;
Type* TypeString = NULL;

void InitBuiltinTypes(void) {
	TypeVoid = createTypeIdentifierString("Void");
	TypeBool = createTypeIdentifierString("Bool");
	TypeInt = createTypeIdentifierString("Int");
	TypeUInt = createTypeIdentifierString("UInt");
	TypeInt8 = createTypeIdentifierString("Int8");
	TypeUInt8 = createTypeIdentifierString("UInt8");
	TypeInt16 = createTypeIdentifierString("Int16");
	TypeUInt16 = createTypeIdentifierString("UInt16");
	TypeInt32 = createTypeIdentifierString("Int32");
	TypeUInt32 = createTypeIdentifierString("UInt32");
	TypeInt64 = createTypeIdentifierString("Int64");
	TypeUInt64 = createTypeIdentifierString("UInt64");
	
	TypeAny = createTypePointer(TypeVoid);
	TypeString = createTypePointer(TypeUInt8);
}
