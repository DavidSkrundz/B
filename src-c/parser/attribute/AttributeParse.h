#pragma once

#include "../../lexer/token/Token.h"
#include "Attribute.h"

Attribute* parseAttribute(Token*** tokens);
