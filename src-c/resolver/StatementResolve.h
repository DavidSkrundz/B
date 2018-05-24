#pragma once

#include "../parser/statement/Statement.h"
#include "type/Type.h"

void resolveStatementBlock(StatementBlock* block, Type* expectedType);
