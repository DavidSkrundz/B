#pragma once

#include "../parser/expression/Expression.h"
#include "type/Type.h"

Type* resolveExpression(Expression* expression, Type* expectedType);
