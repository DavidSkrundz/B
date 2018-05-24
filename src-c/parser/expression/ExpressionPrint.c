#include "ExpressionPrint.h"

#include <stdio.h>
#include <stdlib.h>

#include "../DepthPrint.h"
#include "../../lexer/token/TokenPrint.h"
#include "ExpressionKind.h"
#include "../identifier/IdentifierPrint.h"
#include "../typespec/TypespecPrint.h"

void printExpressionGroup(Expression* expression) {
	printf("(");
	printExpression(expression);
	printf(")");
}

void printExpressionCast(ExpressionCast* expression) {
	printf("(cast ");
	printTypespec(expression->type);
	printf(" ");
	printExpression(expression->expression);
	printf(")");
}

void printExpressionSizeof(ExpressionSizeof* expression) {
	printf("(sizeof ");
	printTypespec(expression->type);
	printf(")");
}

void printExpressionDereference(ExpressionDereference* expression) {
	printf("(dereference ");
	printExpression(expression->expression);
	printf(")");
}

void printExpressionReference(ExpressionReference* expression) {
	printf("(reference ");
	printExpression(expression->expression);
	printf(")");
}

void printExpressionFunctionCall(ExpressionFunctionCall* expression) {
	printf("(call ");
	++depth;
	printExpression(expression->function);
	printf("\n");
	for (int i = 0; i < expression->count; ++i) {
		printDepth();
		printExpression(expression->arguments[i]);
		printf("\n");
	}
	--depth;
	printDepth();
	printf(")");
}

void printExpressionSubscript(ExpressionSubscript* expression) {
	printf("(subscript\n");
	++depth;
	printDepth();
	printExpression(expression->base);
	printf("\n");
	printDepth();
	printExpression(expression->subscript);
	printf("\n");
	--depth;
	printDepth();
	printf(")");
}

void printExpressionArrow(ExpressionArrow* expression) {
	printf("(->\n");
	++depth;
	printDepth();
	printExpression(expression->base);
	printf("\n");
	printDepth();
	printIdentifier(expression->field);
	printf("\n");
	--depth;
	printDepth();
	printf(")");
}

void printExpressionInfix(ExpressionInfix* expression) {
	printf("(");
	printToken(expression->operator);
	printf("\n");
	++depth;
	printDepth();
	printExpression(expression->lhs);
	printf("\n");
	printDepth();
	printExpression(expression->rhs);
	printf("\n");
	--depth;
	printDepth();
	printf(")");
}

void printExpressionIdentifier(ExpressionIdentifier* expression) {
	printIdentifier(expression->identifier);
}

void printExpressionBooleanLiteral(ExpressionBooleanLiteral* expression) {
	printf("(boolean %.*s)", expression->literal->length, expression->literal->value);
}

void printExpressionIntegerLiteral(ExpressionIntegerLiteral* expression) {
	printf("(integer %.*s)", expression->literal->length, expression->literal->value);
}

void printExpressionStringLiteral(ExpressionStringLiteral* expression) {
	printf("(string \"%.*s\"))", expression->literal->length, expression->literal->value);
}

void printExpression(Expression* expression) {
	if (expression->kind == ExpressionKind_Group) {
		printExpressionGroup(expression->expression);
	} else if (expression->kind == ExpressionKind_Cast) {
		printExpressionCast(expression->expression);
	} else if (expression->kind == ExpressionKind_Sizeof) {
		printExpressionSizeof(expression->expression);
	} else if (expression->kind == ExpressionKind_Dereference) {
		printExpressionDereference(expression->expression);
	} else if (expression->kind == ExpressionKind_Reference) {
		printExpressionReference(expression->expression);
	} else if (expression->kind == ExpressionKind_FunctionCall) {
		printExpressionFunctionCall(expression->expression);
	} else if (expression->kind == ExpressionKind_Subscript) {
		printExpressionSubscript(expression->expression);
	} else if (expression->kind == ExpressionKind_Arrow) {
		printExpressionArrow(expression->expression);
	} else if (expression->kind == ExpressionKind_InfixOperator) {
		printExpressionInfix(expression->expression);
	} else if (expression->kind == ExpressionKind_Identifier) {
		printExpressionIdentifier(expression->expression);
	} else if (expression->kind == ExpressionKind_NULL) {
		printf("NULL");
	} else if (expression->kind == ExpressionKind_BooleanLiteral) {
		printExpressionBooleanLiteral(expression->expression);
	} else if (expression->kind == ExpressionKind_IntegerLiteral) {
		printExpressionIntegerLiteral(expression->expression);
	} else if (expression->kind == ExpressionKind_StringLiteral) {
		printExpressionStringLiteral(expression->expression);
	} else {
		fprintf(stderr, "Invalid expression kind %d\n", expression->kind);
		abort();
	}
}
