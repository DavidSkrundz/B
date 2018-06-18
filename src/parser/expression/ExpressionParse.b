func expectExpressionPrimary(): Expression* {
	var expression = newExpression();
	if (checkToken(.OpenParenthesis)) {
		expression->kind = .Group;
		expression->expression = (Void*)expectExpression();
		expectToken(.CloseParenthesis);
	} else if (checkKeyword(Keyword_NULL)) {
		expression->kind = .Null;
	} else if (isTokenKeyword(Keyword_True) || isTokenKeyword(Keyword_False)) {
		expression->kind = .BooleanLiteral;
		var literal = newExpressionBooleanLiteral();
		literal->literal = *_tokens;
		advanceParser(1);
		expression->expression = (Void*)literal;
	} else if (isToken(.IntegerLiteral)) {
		expression->kind = .IntegerLiteral;
		var literal = newExpressionIntegerLiteral();
		literal->literal = *_tokens;
		advanceParser(1);
		expression->expression = (Void*)literal;
	} else if (isToken(.CharacterLiteral)) {
		expression->kind = .CharacterLiteral;
		var literal = newExpressionCharacterLiteral();
		literal->literal = *_tokens;
		advanceParser(1);
		expression->expression = (Void*)literal;
	} else if (isToken(.StringLiteral)) {
		expression->kind = .StringLiteral;
		var literal = newExpressionStringLiteral();
		literal->literal = *_tokens;
		advanceParser(1);
		expression->expression = (Void*)literal;
	} else if (isToken(.Identifier)) {
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
		var argument = expectExpression();
		append((Void***)&expression->arguments, (Void*)argument);
		loop = checkToken(.Comma);
	};
	expectToken(.CloseParenthesis);
	return expression;
};

func expectExpressionSubscript(): ExpressionSubscript* {
	var expression = newExpressionSubscript();
	expectToken(.OpenBracket);
	expression->subscript = expectExpression();
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
	var expression = expectExpressionPrimary();
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

func expectExpressionAdditive(): Expression* {
	var expression = expectExpressionMultiplicative();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (isToken(.Plus)) {
			infix->operator = *_tokens;
			checkToken(.Plus);
		} else if (isToken(.Minus)) {
			infix->operator = *_tokens;
			checkToken(.Minus);
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

func expectExpressionComparison(): Expression* {
	var expression = expectExpressionAdditive();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (isToken(.LessThan)) {
			infix->operator = *_tokens;
			checkToken(.LessThan);
		} else if (isToken(.LessThanEqual)) {
			infix->operator = *_tokens;
			checkToken(.LessThanEqual);
		} else { loop = false; };;
		if (loop) {
			infix->lhs = expression;
			infix->rhs = expectExpressionAdditive();
			expression = newExpression();
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func expectExpressionEquality(): Expression* {
	var expression = expectExpressionComparison();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (isToken(.Equal)) {
			infix->operator = *_tokens;
			checkToken(.Equal);
		} else if (isToken(.NotEqual)) {
			infix->operator = *_tokens;
			checkToken(.NotEqual);
		} else { loop = false; };;
		if (loop) {
			infix->lhs = expression;
			infix->rhs = expectExpressionComparison();
			expression = newExpression();
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func expectExpressionLogicalAND(): Expression* {
	var expression = expectExpressionEquality();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (isToken(.AndAnd)) {
			infix->operator = *_tokens;
			checkToken(.AndAnd);
		} else { loop = false; };
		if (loop) {
			infix->lhs = expression;
			infix->rhs = expectExpressionEquality();
			expression = newExpression();
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func expectExpressionLogicalOR(): Expression* {
	var expression = expectExpressionLogicalAND();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (isToken(.OrOr)) {
			infix->operator = *_tokens;
			checkToken(.OrOr);
		} else { loop = false; };
		if (loop) {
			infix->lhs = expression;
			infix->rhs = expectExpressionLogicalAND();
			expression = newExpression();
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func expectExpression(): Expression* {
	return expectExpressionLogicalOR();
};
