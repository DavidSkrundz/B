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
	} else if (checkToken(.Not)) {
		var expr = newExpressionPrefix();
		expr->operator = previousToken();
		expr->expression = expectExpressionPostfix();
		var expression = newExpression();
		expression->pos = pos;
		expression->kind = .PrefixOperator;
		expression->expression = (Void*)expr;
		return expression;
	} else {
		return expectExpressionPostfix();
	};;;;;;
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

func expectExpressionBitwiseShift(): Expression* {
	var expression = expectExpressionCast();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (checkToken(.LeftShift)) {}
		else if (checkToken(.RightShift)) {}
		else { loop = false; };;
		if (loop) {
			infix->operator = previousToken();
			infix->lhs = expression;
			expression = newExpression();
			expression->pos = previousToken()->pos;
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
			infix->rhs = expectExpressionCast();
		};
	};
	return expression;
};

func expectExpressionMultiplicative(): Expression* {
	var expression = expectExpressionBitwiseShift();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (checkToken(.Star)) {}
		else if (checkToken(.Slash)) {}
		else if (checkToken(.And)) {}
		else { loop = false; };;;
		if (loop) {
			infix->operator = previousToken();
			infix->lhs = expression;
			expression = newExpression();
			expression->pos = previousToken()->pos;
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
			infix->rhs = expectExpressionBitwiseShift();
		};
	};
	return expression;
};

func expectExpressionAdditive(): Expression* {
	var expression = expectExpressionMultiplicative();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (checkToken(.Plus)) {}
		else if (checkToken(.Minus)) {}
		else if (checkToken(.Or)) {}
		else if (checkToken(.Xor)) {}
		else { loop = false; };;;;
		if (loop) {
			infix->operator = previousToken();
			infix->lhs = expression;
			expression = newExpression();
			expression->pos = previousToken()->pos;
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
			infix->rhs = expectExpressionMultiplicative();
		};
	};
	return expression;
};

func expectExpressionComparison(): Expression* {
	var expression = expectExpressionAdditive();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (checkToken(.LessThan)) {}
		else if (checkToken(.LessThanEqual)) {}
		else if (checkToken(.GreaterThan)) {}
		else if (checkToken(.GreaterThanEqual)) {}
		else { loop = false; };;;;
		if (loop) {
			infix->operator = previousToken();
			infix->lhs = expression;
			expression = newExpression();
			expression->pos = previousToken()->pos;
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
			infix->rhs = expectExpressionAdditive();
		};
	};
	return expression;
};

func expectExpressionEquality(): Expression* {
	var expression = expectExpressionComparison();
	var loop = true;
	while (loop) {
		var infix = newExpressionInfixOperator();
		if (checkToken(.Equal)) {}
		else if (checkToken(.NotEqual)) {}
		else { loop = false; };;
		if (loop) {
			infix->operator = previousToken();
			infix->lhs = expression;
			expression = newExpression();
			expression->pos = previousToken()->pos;
			expression->kind = .InfixOperator;
			expression->expression = (Void*)infix;
			infix->rhs = expectExpressionComparison();
		};
	};
	return expression;
};

func expectExpressionConjunction(): Expression* {
	var expression = expectExpressionEquality();
	while (checkToken(.AndAnd)) {
		var infix = newExpressionInfixOperator();
		infix->operator = previousToken();
		infix->lhs = expression;
		expression = newExpression();
		expression->pos = previousToken()->pos;
		expression->kind = .InfixOperator;
		expression->expression = (Void*)infix;
		infix->rhs = expectExpressionEquality();
	};
	return expression;
};

func expectExpressionDisjunction(): Expression* {
	var expression = expectExpressionConjunction();
	while (checkToken(.OrOr)) {
		var infix = newExpressionInfixOperator();
		infix->operator = previousToken();
		infix->lhs = expression;
		expression = newExpression();
		expression->pos = previousToken()->pos;
		expression->kind = .InfixOperator;
		expression->expression = (Void*)infix;
		infix->rhs = expectExpressionConjunction();
	};
	return expression;
};

func expectExpressionTernary(): Expression* {
	var expression = expectExpressionDisjunction();
	if (checkToken(.Question)) {
		var ternary = newExpressionTernary();
		ternary->condition = expression;
		expression = newExpression();
		expression->pos = previousToken()->pos;
		expression->kind = .Ternary;
		expression->expression = (Void*)ternary;
		ternary->positive = expectExpressionTernary();
		expectToken(.Colon);
		ternary->negative = expectExpressionTernary();
	};
	return expression;
};

func expectExpression(): Expression* {
	return expectExpressionTernary();
};
