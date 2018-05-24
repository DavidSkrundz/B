#pragma once

#include "Type.h"

extern Type* TypeVoid;
extern Type* TypeBool;
extern Type* TypeInt;
extern Type* TypeUInt;
extern Type* TypeInt8;
extern Type* TypeUInt8;
extern Type* TypeInt16;
extern Type* TypeUInt16;
extern Type* TypeInt32;
extern Type* TypeUInt32;
extern Type* TypeInt64;
extern Type* TypeUInt64;

extern Type* TypeAny;
extern Type* TypeString;

void InitBuiltinTypes(void);
