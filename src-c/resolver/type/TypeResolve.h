#pragma once

#include <stdbool.h>

#include "../../parser/identifier/Identifier.h"
#include "Type.h"

bool isPointer(Type* type);
Type* getPointerBase(Type* type);

Type* resolveTypeIdentifier(Identifier* name);
Type* resolveTypePointer(Type* base);
Type* resolveTypeFunction(Type* returnType, Type** argumentTypes, int argumentCount, bool isVariadic);

Type* createTypeIdentifierString(char* name);
Type* createTypeIdentifier(Identifier* name);
Type* createTypeAlias(Identifier* name, Type* base);
Type* createTypePointer(Type* base);
Type* createTypeFunction(Type* returnType, Type** argumentTypes, int argumentCount, bool isVariadic);
