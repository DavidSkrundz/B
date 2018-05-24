#pragma once

#include "../../lexer/token/Token.h"
#include "Expression.h"

Expression* parseExpression(Token*** tokens);
