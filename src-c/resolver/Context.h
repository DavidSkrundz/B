#pragma once

#include "../parser/identifier/Identifier.h"
#include "type/Type.h"

typedef struct {
	Identifier** names;
	Type** types;
	int count;
} Context;

Context* newContext(void);
void addTo(Context* context, Identifier* name, Type* type);
