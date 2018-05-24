#pragma once

#include <stdbool.h>

typedef struct {
	int kind;
	void* type;
} Type;

typedef struct {
	char* name;
} TypeIdentifier;

typedef struct {
	Type* base;
} TypePointer;

typedef struct {
	Type* returnType;
	Type** argumentTypes;
	int count;
	bool isVariadic;
} TypeFunction;

Type* newType(void);
TypeIdentifier* newTypeIdentifier(void);
TypePointer* newTypePointer(void);
TypeFunction* newTypeFunction(void);
