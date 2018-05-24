#pragma once

#include "declaration/Declaration.h"
#include "../lexer/token/Token.h"

extern Declaration** declarations;
extern int declarationCount;

void Parse(void);
