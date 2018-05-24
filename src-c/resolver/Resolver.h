#pragma once

#include "../parser/declaration/Declaration.h"
#include "type/Type.h"
#include "Context.h"

extern Type** types;
extern int typeCount;
extern Context* context;

void Resolve(void);
