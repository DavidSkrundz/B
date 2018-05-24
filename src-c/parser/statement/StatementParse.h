#pragma once

#include "../../lexer/token/Token.h"
#include "Statement.h"

StatementBlock* parseStatementBlock(Token*** tokens);
