#pragma once

#include <stdbool.h>

#include "../../resolver/type/Type.h"
#include "../typespec/Typespec.h"
#include "../../lexer/token/Token.h"

typedef struct {
	int kind;
	void* expression;
	Type* resolvedType;
} Expression;

typedef struct {
	Typespec* type;
	Expression* expression;
} ExpressionCast;

typedef struct {
	Typespec* type;
	Type* resolvedType;
} ExpressionSizeof;

typedef struct {
	Expression* expression;
} ExpressionDereference;

typedef struct {
	Expression* expression;
} ExpressionReference;

typedef struct {
	Expression* function;
	Expression** arguments;
	int count;
} ExpressionFunctionCall;

typedef struct {
	Expression* base;
	Expression* subscript;
} ExpressionSubscript;

typedef struct {
	Expression* base;
	Identifier* field;
} ExpressionArrow;

typedef struct {
	Expression* lhs;
	Expression* rhs;
	Token* operator;
} ExpressionInfix;

typedef struct {
	Identifier* identifier;
} ExpressionIdentifier;

typedef struct {
	Token* literal;
} ExpressionBooleanLiteral;

typedef struct {
	Token* literal;
} ExpressionIntegerLiteral;

typedef struct {
	Token* literal;
} ExpressionStringLiteral;

Expression* newExpression(void);
ExpressionCast* newExpressionCast(void);
ExpressionSizeof* newExpressionSizeof(void);
ExpressionDereference* newExpressionDereference(void);
ExpressionReference* newExpressionReference(void);
ExpressionFunctionCall* newExpressionFunctionCall(void);
ExpressionSubscript* newExpressionSubscript(void);
ExpressionArrow* newExpressionArrow(void);
ExpressionInfix* newExpressionInfixOperator(void);
ExpressionIdentifier* newExpressionIdentifier(void);
ExpressionBooleanLiteral* newExpressionBooleanLiteral(void);
ExpressionIntegerLiteral* newExpressionIntegerLiteral(void);
ExpressionStringLiteral* newExpressionStringLiteral(void);
