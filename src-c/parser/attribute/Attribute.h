#pragma once

#include "../identifier/Identifier.h"

typedef struct {
	Identifier* name;
} Attribute;

Attribute* newAttribute(void);
