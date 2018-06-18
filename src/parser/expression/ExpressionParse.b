func parseExpressionPrimary(tokens: Token***): Expression* {
	var expression = newExpression();
	if (checkToken(.OpenParenthesis)) {
		expression->kind = .Group;
		expression->expression = (Void*)parseExpression(tokens);
		if ((**tokens)->kind != .CloseParenthesis) { return NULL; };
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	} else if (checkKeyword(Keyword_NULL)) {
		expression->kind = .Null;
	} else if (isTokenKeyword(Keyword_True) || isTokenKeyword(Keyword_False)) {
		expression->kind = .BooleanLiteral;
		var literal = newExpressionBooleanLiteral();
		literal->literal = **tokens;
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		expression->expression = (Void*)literal;
	} else if ((**tokens)->kind == .IntegerLiteral) {
		expression->kind = .IntegerLiteral;
		var literal = newExpressionIntegerLiteral();
		literal->literal = **tokens;
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		expression->expression = (Void*)literal;
	} else if ((**tokens)->kind == .CharacterLiteral) {
		expression->kind = .CharacterLiteral;
		var literal = newExpressionCharacterLiteral();
		literal->literal = **tokens;
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		expression->expression = (Void*)literal;
	} else if ((**tokens)->kind == .StringLiteral) {
		expression->kind = .StringLiteral;
		var literal = newExpressionStringLiteral();
		literal->literal = **tokens;
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		expression->expression = (Void*)literal;
	} else if ((**tokens)->kind == .Identifier) {
		expression->kind = .Identifier;
		var identifier = newExpressionIdentifier();
		identifier->identifier = expectIdentifier();
		expression->expression = (Void*)identifier;
	} else { return NULL; };;;;;;;
	return expression;
};


func parseExpressionFunctionCallArguments(tokens: Token***): ExpressionFunctionCall* {
	var expression = newExpressionFunctionCall();
	expectToken(.OpenParenthesis);
	var loop = true;
	while ((**tokens)->kind != .CloseParenthesis && loop) {
		var argument = parseExpression(tokens);
		if (argument == NULL) { return NULL; };
		append((Void***)&expression->arguments, (Void*)argument);
		loop = checkToken(.Comma);
	};
	expectToken(.CloseParenthesis);
	return expression;
};

func expectExpressionSubscript(): ExpressionSubscript* {
	var expression = newExpressionSubscript();
	expectToken(.OpenBracket);
	expression->subscript = parseExpression(&_tokens);
	if (expression->subscript == NULL) { ParserErrorTmp("expected expression"); };
	expectToken(.CloseBracket);
	return expression;
};

func expectExpressionArrow(): ExpressionArrow* {
	expectToken(.Arrow);
	return newExpressionArrow(expectIdentifier());
};

func parseExpressionDot(tokens: Token***): ExpressionDot* {
	var expression = newExpressionDot();
	expectToken(.Dot);
	expression->field = expectIdentifier();
	return expression;
};

func parseExpressionPostfix(tokens: Token***): Expression* {
	var expression = parseExpressionPrimary(tokens);
	if (expression == NULL) { return NULL; };
	var loop = true;
	while (loop) {
		if ((**tokens)->kind == .OpenParenthesis) {
			var f = parseExpressionFunctionCallArguments(tokens);
			if (f == NULL) { return NULL; };
			f->function = expression;
			expression = newExpression();
			expression->kind = .FunctionCall;
			expression->expression = (Void*)f;
		} else if ((**tokens)->kind == .OpenBracket) {
			var subscript = expectExpressionSubscript();
			subscript->base = expression;
			expression = newExpression();
			expression->kind = .Subscript;
			expression->expression = (Void*)subscript;
		} else if ((**tokens)->kind == .Arrow) {
			var arrow = expectExpressionArrow();
			arrow->base = expression;
			expression = newExpression();
			expression->kind = .Arrow;
			expression->expression = (Void*)arrow;
		} else if ((**tokens)->kind == .Dot) {
			if (expression->kind != .Identifier) { return NULL; };
			var dot = parseExpressionDot(tokens);
			if (dot == NULL) { return NULL; };
			dot->base = ((ExpressionIdentifier*)expression->expression)->identifier;
			expression = newExpression();
			expression->kind = .Dot;
			expression->expression = (Void*)dot;
		} else { loop = false; };;;;
	};
	return expression;
};

func expectExpressionUnary(): Expression* {
	if (checkKeyword(Keyword_Sizeof)) {
		expectToken(.OpenParenthesis);
		var expr = newExpressionSizeof();
		expr->type = expectTypespec();
		expectToken(.CloseParenthesis);
		var expression = newExpression();
		expression->kind = .Sizeof;
		expression->expression = (Void*)expr;
		return expression;
	} else if (checkKeyword(Keyword_Offsetof)) {
		expectToken(.OpenParenthesis);
		var expr = newExpressionOffsetof();
		expr->type = expectTypespec();
		expectToken(.Comma);
		expr->field = expectIdentifier();
		expectToken(.CloseParenthesis);
		var expression = newExpression();
		expression->kind = .Offsetof;
		expression->expression = (Void*)expr;
		return expression;
	} else if (checkToken(.Star)) {
		var expr = newExpressionDereference();
		expr->expression = expectExpressionCast();
		var expression = newExpression();
		expression->kind = .Dereference;
		expression->expression = (Void*)expr;
		return expression;
	} else if (checkToken(.And)) {
		var expr = newExpressionReference();
		expr->expression = expectExpressionCast();
		var expression = newExpression();
		expression->kind = .Reference;
		expression->expression = (Void*)expr;
		return expression;
	} else if (isToken(.Dot)) {
		var expr = parseExpressionDot(&_tokens);
		if (expr == NULL) { return parseExpressionPostfix(&_tokens); };
		var expression = newExpression();
		expression->kind = .Dot;
		expression->expression = (Void*)expr;
		return expression;
	} else {
		return parseExpressionPostfix(&_tokens);
	};;;;;
};

func expectExpressionCast(): Expression* {
	var save = _tokens;
	if (checkToken(.OpenParenthesis)) {
		var expression = newExpression();
		expression->kind = .Cast;
		var expressionCast = newExpressionCast();
		expression->expression = (Void*)expressionCast;
		expressionCast->type = parseTypespec(&_tokens);
		if (expressionCast->type == NULL) {
			_tokens = save;
			return expectExpressionUnary();
		};
		if (checkToken(.CloseParenthesis) == false) {
			_tokens = save;
			return expectExpressionUnary();
		};
		expressionCast->expression = expectExpressionCast();
		return expression;
	} else {
		return expectExpressionUnary();
	};
};

func expectExpressionMultiplicative(): Expression* {
	var expression = expectExpressionCast();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (isToken(.Star)) {
			infix->operator = *_tokens;
			checkToken(.Star);
		} else if (isToken(.Slash)) {
			infix->operator = *_tokens;
			checkToken(.Slash);
		} else if (isToken(.And)) {
			infix->operator = *_tokens;
			checkToken(.And);
		} else { loop = false; };;;
		if (loop) {
			infix->lhs = expression;
			infix->rhs = expectExpressionCast();
			expression = newExpression();
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func parseExpressionAdditive(tokens: Token***): Expression* {
	var expression = expectExpressionMultiplicative();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if ((**tokens)->kind == .Plus) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else if ((**tokens)->kind == .Minus) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };;
		if (loop) {
			infix->lhs = expression;
			infix->rhs = expectExpressionMultiplicative();
			expression = newExpression();
			expression->kind = .InfixOperator;
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
		if ((**tokens)->kind == .LessThan) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else if ((**tokens)->kind == .LessThanEqual) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };;
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionAdditive(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = .InfixOperator;
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
		if ((**tokens)->kind == .Equal) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else if ((**tokens)->kind == .NotEqual) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };;
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionComparison(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = .InfixOperator;
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
		if ((**tokens)->kind == .AndAnd) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionEquality(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = .InfixOperator;
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
		if ((**tokens)->kind == .OrOr) {
			infix->operator = **tokens;
			*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		} else { loop = false; };
		if (loop) {
			infix->lhs = expression;
			infix->rhs = parseExpressionLogicalAND(tokens);
			if (infix->rhs == NULL) { return NULL; };
			expression = newExpression();
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func parseExpression(tokens: Token***): Expression* {
	return parseExpressionLogicalOR(tokens);
};
