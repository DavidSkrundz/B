struct Expression {
	var pos: SrcPos*;
	var kind: ExpressionKind;
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

struct ExpressionOffsetof {
	var type: Typespec*;
	var field: Token*;
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
};

struct ExpressionSubscript {
	var base: Expression*;
	var subscript: Expression*;
};

struct ExpressionArrow {
	var base: Expression*;
	var field: Token*;
};

struct ExpressionDot {
	var base: Token*;
	var field: Token*;
};

struct ExpressionPrefix {
	var expression: Expression*;
	var operator: Token*;
};

struct ExpressionInfix {
	var lhs: Expression*;
	var rhs: Expression*;
	var operator: Token*;
};

struct ExpressionTernary {
	var condition: Expression*;
	var positive: Expression*;
	var negative: Expression*;
};

struct ExpressionIdentifier {
	var identifier: Token*;
};

struct ExpressionBooleanLiteral {
	var literal: Token*;
};

struct ExpressionIntegerLiteral {
	var literal: Token*;
};

struct ExpressionCharacterLiteral {
	var literal: Token*;
};

struct ExpressionStringLiteral {
	var literal: Token*;
};

func newExpression(): Expression* {
	return (Expression*)xcalloc(1, sizeof(Expression));
};

func newExpressionCast(): ExpressionCast* {
	return (ExpressionCast*)xcalloc(1, sizeof(ExpressionCast));
};

func newExpressionSizeof(): ExpressionSizeof* {
	return (ExpressionSizeof*)xcalloc(1, sizeof(ExpressionSizeof));
};

func newExpressionOffsetof(): ExpressionOffsetof* {
	return (ExpressionOffsetof*)xcalloc(1, sizeof(ExpressionOffsetof));
};

func newExpressionDereference(): ExpressionDereference* {
	return (ExpressionDereference*)xcalloc(1, sizeof(ExpressionDereference));
};

func newExpressionReference(): ExpressionReference* {
	return (ExpressionReference*)xcalloc(1, sizeof(ExpressionReference));
};

func newExpressionFunctionCall(): ExpressionFunctionCall* {
	return (ExpressionFunctionCall*)xcalloc(1, sizeof(ExpressionFunctionCall));
};

func newExpressionSubscript(): ExpressionSubscript* {
	return (ExpressionSubscript*)xcalloc(1, sizeof(ExpressionSubscript));
};

func newExpressionArrow(field: Token*): ExpressionArrow* {
	var expression = (ExpressionArrow*)xcalloc(1, sizeof(ExpressionArrow));
	expression->field = field;
	return expression;
};

func newExpressionDot(): ExpressionDot* {
	return (ExpressionDot*)xcalloc(1, sizeof(ExpressionDot));
};

func newExpressionPrefix(): ExpressionPrefix* {
	return (ExpressionPrefix*)xcalloc(1, sizeof(ExpressionPrefix));
};

func newExpressionInfixOperator(): ExpressionInfix* {
	return (ExpressionInfix*)xcalloc(1, sizeof(ExpressionInfix));
};

func newExpressionTernary(): ExpressionTernary* {
	return (ExpressionTernary*)xcalloc(1, sizeof(ExpressionTernary));
};

func newExpressionIdentifier(): ExpressionIdentifier* {
	return (ExpressionIdentifier*)xcalloc(1, sizeof(ExpressionIdentifier));
};

func newExpressionBooleanLiteral(): ExpressionBooleanLiteral* {
	return (ExpressionBooleanLiteral*)xcalloc(1, sizeof(ExpressionBooleanLiteral));
};

func newExpressionIntegerLiteral(): ExpressionIntegerLiteral* {
	return (ExpressionIntegerLiteral*)xcalloc(1, sizeof(ExpressionIntegerLiteral));
};

func newExpressionCharacterLiteral(): ExpressionCharacterLiteral* {
	return (ExpressionCharacterLiteral*)xcalloc(1, sizeof(ExpressionCharacterLiteral));
};

func newExpressionStringLiteral(): ExpressionStringLiteral* {
	return (ExpressionStringLiteral*)xcalloc(1, sizeof(ExpressionStringLiteral));
};
