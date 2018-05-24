#pragma once

#include "../identifier/Identifier.h"

typedef struct {
	int kind;
	void* spec;
} Typespec;

typedef struct {
	Typespec* base;
} TypespecPointer;

typedef struct {
	Identifier* name;
} TypespecIdentifier;

Typespec* newTypespec(void);
TypespecPointer* newTypespecPointer(void);
TypespecIdentifier* newTypespecIdentifier(void);
