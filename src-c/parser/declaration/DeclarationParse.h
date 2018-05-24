#pragma once

#include "../../lexer/token/Token.h"
#include "Declaration.h"

Declaration* parseDeclaration(Token*** tokens);
