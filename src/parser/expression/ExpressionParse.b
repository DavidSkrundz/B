func parseExpressionPrimary(tokens: Token***): Expression* {
	var expression = newExpression();
	if (checkToken(TokenKind_OpenParenthesis)) {
		expression->kind = ExpressionKind_Group;
		expression->expression = (Void*)parseExpression(tokens);
		if ((**tokens)->kind != TokenKind_CloseParenthesis) { return NULL; };
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	} else if ((**tokens)->kind == TokenKind_Identifier) {
		expression->kind = ExpressionKind_Identifier;
		var identifier = newExpressionIdentifier();
		identifier->identifier = parseIdentifier(tokens);
		expression->expression = (Void*)identifier;
	} else if (checkToken(TokenKind_NULL)) {
		expression->kind = ExpressionKind_NULL;
	} else if ((**tokens)->kind == TokenKind_BooleanLiteral) {
		expression->kind = ExpressionKind_BooleanLiteral;
		var literal = newExpressionBooleanLiteral();
		literal->literal = **tokens;
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		expression->expression = (Void*)literal;
	} else if ((**tokens)->kind == TokenKind_IntegerLiteral) {
		expression->kind = ExpressionKind_IntegerLiteral;
		var literal = newExpressionIntegerLiteral();
		literal->literal = **tokens;
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		expression->expression = (Void*)literal;
	} else if ((**tokens)->kind == TokenKind_StringLiteral) {
		expression->kind = ExpressionKind_StringLiteral;
		var literal = newExpressionStringLiteral();
		literal->literal = **tokens;
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		expression->expression = (Void*)literal;
	} else { return NULL; };;;;;;
	return expression;
};

func parseExpressionFunctionCallArguments(tokens: Token***): ExpressionFunctionCall* {
	var expression = newExpressionFunctionCall();
	expectToken(TokenKind_OpenParenthesis);
	expression->arguments = (Expression**)xcalloc(MAX_FUNC_ARGUMENT_COUNT, sizeof(Expression*));
	expression->count = (UInt)0;
	var loop = true;
	while ((**tokens)->kind != TokenKind_CloseParenthesis && loop) {
		if (expression->count == MAX_FUNC_ARGUMENT_COUNT) {
			fprintf(stderr, (char*)"Too many arguments in function call%c", 10);
			exit(EXIT_FAILURE);
		};
		var argument = parseExpression(tokens);
		if (argument == NULL) { return NULL; };
		expression->arguments[expression->count] = argument;
		expression->count = expression->count + (UInt)1;
		loop = checkToken(TokenKind_Comma);
	};
	expectToken(TokenKind_CloseParenthesis);
	return expression;
};

func parseExpressionSubscript(tokens: Token***): ExpressionSubscript* {
	var expression = newExpressionSubscript();
	expectToken(TokenKind_OpenBracket);
	expression->subscript = parseExpression(tokens);
	if (expression->subscript == NULL) { return NULL; };
	expectToken(TokenKind_CloseBracket);
	return expression;
};

func parseExpressionArrow(tokens: Token***): ExpressionArrow* {
	var expression = newExpressionArrow();
	expectToken(TokenKind_Arrow);
	expression->field = parseIdentifier(tokens);
	if (expression->field == NULL) { return NULL; };
	return expression;
};

func parseExpressionPostfix(tokens: Token***): Expression* {
	var expression = parseExpressionPrimary(tokens);
	if (expression == NULL) { return NULL; };
	var loop = true;
	while (loop) {
		if ((**tokens)->kind == TokenKind_OpenParenthesis) {
			var f = parseExpressionFunctionCallArguments(tokens);
			if (f == NULL) { return NULL; };
			f->function = expression;
			expression = newExpression();
			expression->kind = ExpressionKind_FunctionCall;
			expression->expression = (Void*)f;
		} else if ((**tokens)->kind == TokenKind_OpenBracket) {
			var subscript = parseExpressionSubscript(tokens);
			if (subscript == NULL) { return NULL; };
			subscript->base = expression;
			expression = newExpression();
			expression->kind = ExpressionKind_Subscript;
			expression->expression = (Void*)subscript;
		} else if ((**tokens)->kind == TokenKind_Arrow) {
			var arrow = parseExpressionArrow(tokens);
			if (arrow == NULL) { return NULL; };
			arrow->base = expression;
			expression = newExpression();
			expression->kind = ExpressionKind_Arrow;
			expression->expression = (Void*)arrow;
		} else { loop = false; };;;
	};
	return expression;
};

func parseExpressionUnary(tokens: Token***): Expression* {
	if (checkToken(TokenKind_Sizeof)) {
		expectToken(TokenKind_OpenParenthesis);
		var expr = newExpressionSizeof();
		expr->type = parseTypespec(tokens);
		if (expr->type == NULL) { return NULL; };
		expectToken(TokenKind_CloseParenthesis);
		var expression = newExpression();
		expression->kind = ExpressionKind_Sizeof;
		expression->expression = (Void*)expr;
		return expression;
	} else if (checkToken(TokenKind_Star)) {
		var expr = newExpressionDereference();
		expr->expression = parseExpressionCast(tokens);
		if (expr->expression == NULL) { return NULL; };
		var expression = newExpression();
		expression->kind = ExpressionKind_Dereference;
		expression->expression = (Void*)expr;
		return expression;
	} else if (checkToken(TokenKind_And)) {
		var expr = newExpressionReference();
		expr->expression = parseExpressionCast(tokens);
		if (expr->expression == NULL) { return NULL; };
		var expression = newExpression();
		expression->kind = ExpressionKind_Reference;
		expression->expression = (Void*)expr;
		return expression;
	} else {
		return parseExpressionPostfix(tokens);
	};;;
};

func parseExpressionCast(tokens: Token***): Expression* {
	var save = *tokens;
	if (checkToken(TokenKind_OpenParenthesis)) {
		var expression = newExpression();
		expression->kind = ExpressionKind_Cast;
		var expressionCast = newExpressionCast();
		expression->expression = (Void*)expressionCast;
		expressionCast->type = parseTypespec(tokens);
		if (expressionCast->type == NULL) {
			*tokens = save;
			return parseExpressionUnary(tokens);
		};
		if (checkToken(TokenKind_CloseParenthesis) == false) {
			*tokens = save;
			return parseExpressionUnary(tokens);
		};
		expressionCast->expression = parseExpressionCast(tokens);
		if (expressionCast->expression == NULL) { return NULL; };
		return expression;
	} else {
		return parseExpressionUnary(tokens);
	};
};

func parseExpressionMultiplicative(tokens: Token***): Expression* {
	var expression = parseExpressionCast(tokens);
	if (expression == NULL) { return NULL; };
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_Star) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else if ((**tokens)->kind == TokenKind_Slash) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else if ((**tokens)->kind == TokenKind_And) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };;;
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionCast(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = ExpressionKind_InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func parseExpressionAdditive(tokens: Token***): Expression* {
	var expression = parseExpressionMultiplicative(tokens);
	if (expression == NULL) { return NULL; };
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_Plus) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else if ((**tokens)->kind == TokenKind_Minus) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };;
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionMultiplicative(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = ExpressionKind_InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func parseExpressionComparison(tokens: Token***): Expression* {
	var expression = parseExpressionAdditive(tokens);
	if (expression == NULL) { return NULL; };
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_LessThan) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionAdditive(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = ExpressionKind_InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func parseExpressionEquality(tokens: Token***): Expression* {
	var expression = parseExpressionComparison(tokens);
	if (expression == NULL) { return NULL; };
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_Equal) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else if ((**tokens)->kind == TokenKind_NotEqual) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };;
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionComparison(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = ExpressionKind_InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func parseExpressionLogicalAND(tokens: Token***): Expression* {
	var expression = parseExpressionEquality(tokens);
	if (expression == NULL) { return NULL; };
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_AndAnd) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionEquality(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = ExpressionKind_InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func parseExpressionLogicalOR(tokens: Token***): Expression* {
	var expression = parseExpressionLogicalAND(tokens);
	if (expression == NULL) { return NULL; };
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_OrOr) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionLogicalAND(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = ExpressionKind_InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func parseExpression(tokens: Token***): Expression* {
	return parseExpressionLogicalOR(tokens);
};
