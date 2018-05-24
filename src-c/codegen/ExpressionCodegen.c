#include "ExpressionCodegen.h"

#include <stdio.h>
#include <stdlib.h>

#include "../parser/expression/ExpressionKind.h"
#include "../resolver/type/TypeKind.h"
#include "TypeCodegen.h"
#include "IdentifierCodegen.h"

void codegenNullExpressionPointer(TypePointer* type) {
	printf("(NULL)");
}

void codegenNullExpression(Type* type) {
	if (type->kind == TypeKind_Pointer) {
		codegenNullExpressionPointer(type->type);
	} else {
		fprintf(stderr, "Invalid type kind %d\n", type->kind);
		abort();
	}
}

void codegenExpressionGroup(Expression* expression, Expression* expr) {
	printf("(");
	codegenExpression(expr);
	printf(")");
}

void codegenExpressionCast(Expression* expression, ExpressionCast* expr) {
	printf("(");
	codegenType(expression->resolvedType);
	printf(")(");
	codegenExpression(expr->expression);
	printf(")");
}

void codegenExpressionDereference(Expression* expression, ExpressionDereference* expr) {
	printf("(*");
	codegenExpression(expr->expression);
	printf(")");
}

void codegenExpressionReference(Expression* expression, ExpressionReference* expr) {
	printf("(&");
	codegenExpression(expr->expression);
	printf(")");
}

void codegenExpressionSizeof(Expression* expression, ExpressionSizeof* expr) {
	printf("sizeof(");
	codegenType(expr->resolvedType);
	printf(")");
}

void codegenExpressionFunctionCall(Expression* expression, ExpressionFunctionCall* expr) {
	printf("(");
	codegenExpression(expr->function);
	printf("(");
	for (int i = 0; i < expr->count; ++i) {
		codegenExpression(expr->arguments[i]);
		if ((i + 1) < expr->count) { printf(", "); }
	}
	printf(")");
	printf(")");
}

void codegenExpressionSubscript(Expression* expression, ExpressionSubscript* expr) {
	printf("(");
	codegenExpression(expr->base);
	printf("[");
	codegenExpression(expr->subscript);
	printf("]");
	printf(")");
}

void codegenExpressionArrow(Expression* expression, ExpressionArrow* expr) {
	printf("(");
	codegenExpression(expr->base);
	printf("->");
	codegenIdentifier(expr->field);
	printf(")");
}

void codegenExpressionInfixOperator(Expression* expression, ExpressionInfix* expr) {
	printf("(");
	codegenExpression(expr->lhs);
	printf(" %.*s ", expr->operator->length, expr->operator->value);
	codegenExpression(expr->rhs);
	printf(")");
}

void codegenExpressionIdentifier(Expression* expression, ExpressionIdentifier* expr) {
	printf("(");
	codegenIdentifier(expr->identifier);
	printf(")");
}

void codegenExpressionBooleanLiteral(Expression* expression, ExpressionBooleanLiteral* expr) {
	printf("(");
	printf("%.*s", expr->literal->length, expr->literal->value);
	printf(")");
}

void codegenExpressionIntegerLiteral(Expression* expression, ExpressionIntegerLiteral* expr) {
	printf("(");
	printf("%.*s", expr->literal->length, expr->literal->value);
	printf(")");
}

void codegenExpressionStringLiteral(Expression* expression, ExpressionStringLiteral* expr) {
	printf("((UInt8*)");
	printf("\"%.*s\"", expr->literal->length, expr->literal->value);
	printf(")");
}

void codegenExpression(Expression* expression) {
	if (expression->kind == ExpressionKind_Group) {
		codegenExpressionGroup(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_Cast) {
		codegenExpressionCast(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_Sizeof) {
		codegenExpressionSizeof(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_Dereference) {
		codegenExpressionDereference(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_Reference) {
		codegenExpressionReference(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_FunctionCall) {
		codegenExpressionFunctionCall(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_Subscript) {
		codegenExpressionSubscript(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_Arrow) {
		codegenExpressionArrow(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_InfixOperator) {
		codegenExpressionInfixOperator(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_Identifier) {
		codegenExpressionIdentifier(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_NULL) {
		printf("NULL");
	} else if (expression->kind == ExpressionKind_BooleanLiteral) {
		codegenExpressionBooleanLiteral(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_IntegerLiteral) {
		codegenExpressionIntegerLiteral(expression, expression->expression);
	} else if (expression->kind == ExpressionKind_StringLiteral) {
		codegenExpressionStringLiteral(expression, expression->expression);
	} else {
		fprintf(stderr, "Invalid expression kind %d\n", expression->kind);
		abort();
	}
}
