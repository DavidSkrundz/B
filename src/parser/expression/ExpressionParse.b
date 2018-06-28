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
	expression->pos = previousToken()->pos;
	return expression;
};

func expectExpressionFunctionCallArguments(): ExpressionFunctionCall* {
	var expression = newExpressionFunctionCall();
	expectToken(.OpenParenthesis);
	var loop = true;
	while (isToken(.CloseParenthesis) == false && loop) {
		Buffer_append((Void***)&expression->arguments, (Void*)expectExpression());
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

func expectExpressionDot(): ExpressionDot* {
	var expression = newExpressionDot();
	expectToken(.Dot);
	expression->field = expectIdentifier();
	return expression;
};

func expectExpressionPostfix(): Expression* {
	var expression = expectExpressionPrimary();
	var loop = true;
	while (loop) {
		var pos = _tokens[0]->pos;
		if (isToken(.OpenParenthesis)) {
			var f = expectExpressionFunctionCallArguments();
			f->function = expression;
			expression = newExpression();
			expression->pos = pos;
			expression->kind = .FunctionCall;
			expression->expression = (Void*)f;
		} else if (isToken(.OpenBracket)) {
			var subscript = expectExpressionSubscript();
			subscript->base = expression;
			expression = newExpression();
			expression->pos = pos;
			expression->kind = .Subscript;
			expression->expression = (Void*)subscript;
		} else if (isToken(.Arrow)) {
			var arrow = expectExpressionArrow();
			arrow->base = expression;
			expression = newExpression();
			expression->pos = pos;
			expression->kind = .Arrow;
			expression->expression = (Void*)arrow;
		} else if (isToken(.Dot)) {
			if (expression->kind != .Identifier) { return NULL; };
			var dot = expectExpressionDot();
			dot->base = ((ExpressionIdentifier*)expression->expression)->identifier;
			expression = newExpression();
			expression->pos = pos;
			expression->kind = .Dot;
			expression->expression = (Void*)dot;
		} else { loop = false; };;;;
	};
	return expression;
};

func expectExpressionUnary(): Expression* {
	var pos = _tokens[0]->pos;
	if (checkKeyword(Keyword_Sizeof)) {
		expectToken(.OpenParenthesis);
		var expr = newExpressionSizeof();
		expr->type = expectTypespec();
		expectToken(.CloseParenthesis);
		var expression = newExpression();
		expression->pos = pos;
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
		expression->pos = pos;
		expression->kind = .Offsetof;
		expression->expression = (Void*)expr;
		return expression;
	} else if (checkToken(.Star)) {
		var expr = newExpressionDereference();
		expr->expression = expectExpressionCast();
		var expression = newExpression();
		expression->pos = pos;
		expression->kind = .Dereference;
		expression->expression = (Void*)expr;
		return expression;
	} else if (checkToken(.And)) {
		var expr = newExpressionReference();
		expr->expression = expectExpressionCast();
		var expression = newExpression();
		expression->pos = pos;
		expression->kind = .Reference;
		expression->expression = (Void*)expr;
		return expression;
	} else if (isToken(.Dot)) {
		var expr = expectExpressionDot();
		var expression = newExpression();
		expression->pos = pos;
		expression->kind = .Dot;
		expression->expression = (Void*)expr;
		return expression;
	} else {
		return expectExpressionPostfix();
	};;;;;
};

func expectExpressionCast(): Expression* {
	var save = _tokens;
	if (checkToken(.OpenParenthesis)) {
		var expression = newExpression();
		expression->pos = previousToken()->pos;
		expression->kind = .Cast;
		var expressionCast = newExpressionCast();
		expression->expression = (Void*)expressionCast;
		expressionCast->type = parseTypespec();
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
			expression->pos = previousToken()->pos;
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
			expression->pos = previousToken()->pos;
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
			expression->pos = previousToken()->pos;
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
			expression->pos = previousToken()->pos;
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
			expression->pos = previousToken()->pos;
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
			expression->pos = previousToken()->pos;
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
		};
	};
	return expression;
};

func expectExpression(): Expression* {
	return expectExpressionLogicalOR();
};
