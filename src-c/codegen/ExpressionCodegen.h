#pragma once

#include "../parser/expression/Expression.h"
#include "../resolver/type/Type.h"

void codegenNullExpression(Type* type);
void codegenExpression(Expression* expression);
