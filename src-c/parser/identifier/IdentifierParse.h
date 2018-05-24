#pragma once

#include "../../lexer/token/Token.h"
#include "Identifier.h"

Identifier* parseIdentifier(Token*** tokens);
