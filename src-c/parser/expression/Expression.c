#include "Expression.h"

#include "../../utility/Memory.h"

Expression* newExpression(void) {
	return xcalloc(1, sizeof(Expression));
}

ExpressionCast* newExpressionCast(void) {
	return xcalloc(1, sizeof(ExpressionCast));
}

ExpressionSizeof* newExpressionSizeof(void) {
	return xcalloc(1, sizeof(ExpressionSizeof));
}

ExpressionDereference* newExpressionDereference(void) {
	return xcalloc(1, sizeof(ExpressionDereference));
}

ExpressionReference* newExpressionReference(void) {
	return xcalloc(1, sizeof(ExpressionReference));
}

ExpressionFunctionCall* newExpressionFunctionCall(void) {
	return xcalloc(1, sizeof(ExpressionFunctionCall));
}

ExpressionSubscript* newExpressionSubscript(void) {
	return xcalloc(1, sizeof(ExpressionSubscript));
}

ExpressionArrow* newExpressionArrow(void) {
	return xcalloc(1, sizeof(ExpressionArrow));
}

ExpressionInfix* newExpressionInfixOperator(void) {
	return xcalloc(1, sizeof(ExpressionInfix));
}

ExpressionIdentifier* newExpressionIdentifier(void) {
	return xcalloc(1, sizeof(ExpressionIdentifier));
}

ExpressionBooleanLiteral* newExpressionBooleanLiteral(void) {
	return xcalloc(1, sizeof(ExpressionBooleanLiteral));
}

ExpressionIntegerLiteral* newExpressionIntegerLiteral(void) {
	return xcalloc(1, sizeof(ExpressionIntegerLiteral));
}

ExpressionStringLiteral* newExpressionStringLiteral(void) {
	return xcalloc(1, sizeof(ExpressionStringLiteral));
}
