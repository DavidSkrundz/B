#pragma once

#include "token/Token.h"

extern Token** tokens;
extern int tokenCount;

void Lex(char* code, int codeLength);
