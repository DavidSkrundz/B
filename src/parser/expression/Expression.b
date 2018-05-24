struct Expression {
	var kind: UInt;
	var expression: Void*;
	var resolvedType: Type*;
};

struct ExpressionCast {
	var type: Typespec*;
	var expression: Expression*;
};

struct ExpressionSizeof {
	var type: Typespec*;
	var resolvedType: Type*;
};

struct ExpressionDereference {
	var expression: Expression*;
};

struct ExpressionReference {
	var expression: Expression*;
};

struct ExpressionFunctionCall {
	var function: Expression*;
	var arguments: Expression**;
	var count: UInt;
};

struct ExpressionSubscript {
	var base: Expression*;
	var subscript: Expression*;
};

struct ExpressionArrow {
	var base: Expression*;
	var field: Identifier*;
};

struct ExpressionInfix {
	var lhs: Expression*;
	var rhs: Expression*;
	var operator: Token*;
};

struct ExpressionIdentifier {
	var identifier: Identifier*;
};

struct ExpressionBooleanLiteral {
	var literal: Token*;
};

struct ExpressionIntegerLiteral {
	var literal: Token*;
};

struct ExpressionStringLiteral {
	var literal: Token*;
};

func newExpression(): Expression* {
	return (Expression*)xcalloc((UInt)1, sizeof(Expression));
};

func newExpressionCast(): ExpressionCast* {
	return (ExpressionCast*)xcalloc((UInt)1, sizeof(ExpressionCast));
};

func newExpressionSizeof(): ExpressionSizeof* {
	return (ExpressionSizeof*)xcalloc((UInt)1, sizeof(ExpressionSizeof));
};

func newExpressionDereference(): ExpressionDereference* {
	return (ExpressionDereference*)xcalloc((UInt)1, sizeof(ExpressionDereference));
};

func newExpressionReference(): ExpressionReference* {
	return (ExpressionReference*)xcalloc((UInt)1, sizeof(ExpressionReference));
};

func newExpressionFunctionCall(): ExpressionFunctionCall* {
	return (ExpressionFunctionCall*)xcalloc((UInt)1, sizeof(ExpressionFunctionCall));
};

func newExpressionSubscript(): ExpressionSubscript* {
	return (ExpressionSubscript*)xcalloc((UInt)1, sizeof(ExpressionSubscript));
};

func newExpressionArrow(): ExpressionArrow* {
	return (ExpressionArrow*)xcalloc((UInt)1, sizeof(ExpressionArrow));
};

func newExpressionInfixOperator(): ExpressionInfix* {
	return (ExpressionInfix*)xcalloc((UInt)1, sizeof(ExpressionInfix));
};

func newExpressionIdentifier(): ExpressionIdentifier* {
	return (ExpressionIdentifier*)xcalloc((UInt)1, sizeof(ExpressionIdentifier));
};

func newExpressionBooleanLiteral(): ExpressionBooleanLiteral* {
	return (ExpressionBooleanLiteral*)xcalloc((UInt)1, sizeof(ExpressionBooleanLiteral));
};

func newExpressionIntegerLiteral(): ExpressionIntegerLiteral* {
	return (ExpressionIntegerLiteral*)xcalloc((UInt)1, sizeof(ExpressionIntegerLiteral));
};

func newExpressionStringLiteral(): ExpressionStringLiteral* {
	return (ExpressionStringLiteral*)xcalloc((UInt)1, sizeof(ExpressionStringLiteral));
};
