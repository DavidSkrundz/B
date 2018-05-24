#pragma once

#include "../../lexer/token/Token.h"
#include "Typespec.h"

Typespec* parseTypespec(Token*** tokens);
