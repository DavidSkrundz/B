func expectStatementIf(): StatementIf* {
	expectKeyword(Keyword_If);
	var statement = newStatementIf();
	expectToken(.OpenParenthesis);
	statement->condition = parseExpression(&_tokens);
	if (statement->condition == NULL) { ParserErrorTmp("expecting expression"); };
	expectToken(.CloseParenthesis);
	statement->block = parseStatementBlock(&_tokens);
	if (statement->block == NULL) { ParserErrorTmp("expecting statement block"); };
	if (checkKeyword(Keyword_Else)) {
		if (isTokenKeyword(Keyword_If) || (*_tokens)->kind == .OpenCurly) {
			statement->elseBlock = parseStatement(&_tokens);
			if (statement->elseBlock == NULL) { ParserErrorTmp("expecting if or block"); };
		} else { ParserErrorTmp("expecting if or block"); };
	};
	expectToken(.Semicolon);
	return statement;
};

func expectStatementWhile(): StatementWhile* {
	expectKeyword(Keyword_While);
	var statement = newStatementWhile();
	expectToken(.OpenParenthesis);
	statement->condition = parseExpression(&_tokens);
	if (statement->condition == NULL) { ParserErrorTmp("expecting expression"); };
	expectToken(.CloseParenthesis);
	statement->block = parseStatementBlock(&_tokens);
	if (statement->block == NULL) { ParserErrorTmp("expecting statement block"); };
	expectToken(.Semicolon);
	return statement;
};

func expectStatementReturn(): StatementReturn* {
	expectKeyword(Keyword_Return);
	var statement = newStatementReturn();
	statement->expression = parseExpression(&_tokens);
	expectToken(.Semicolon);
	return statement;
};

func parseStatementVar(tokens: Token***): StatementVar* {
	var statement = newStatementVar();
	statement->declaration = parseDeclaration(tokens);
	if (statement->declaration == NULL) { return NULL; };
	if (statement->declaration->kind != .Var) { return NULL; };
	return statement;
};

func parseStatementExpression(tokens: Token***): StatementExpression* {
	var expression = newStatementExpression();
	expression->expression = parseExpression(tokens);
	if (expression->expression == NULL) { return NULL; };
	if (checkToken(.Semicolon)) {
		return expression;
	};
	return NULL;
};

func parseStatementAssign(tokens: Token***): StatementAssign* {
	var statement = newStatementAssign();
	statement->lhs = parseExpression(tokens);
	expectToken(.Assign);
	statement->rhs = parseExpression(tokens);
	expectToken(.Semicolon);
	return statement;
};

func parseStatement(tokens: Token***): Statement* {
	var statement = newStatement();
	if (isTokenKeyword(Keyword_If)) {
		statement->kind = .If;
		statement->statement = (Void*)expectStatementIf();
	} else if (isTokenKeyword(Keyword_While)) {
		statement->kind = .While;
		statement->statement = (Void*)expectStatementWhile();
	} else if (isTokenKeyword(Keyword_Return)) {
		statement->kind = .Return;
		statement->statement = (Void*)expectStatementReturn();
	} else if (isTokenKeyword(Keyword_Var)) {
		statement->kind = .Var;
		statement->statement = (Void*)parseStatementVar(tokens);
	} else if ((**tokens)->kind == .OpenCurly) {
		statement->kind = .Block;
		statement->statement = (Void*)parseStatementBlock(tokens);
	} else {
		var before = *tokens;
		statement->kind = .Expression;
		statement->statement = (Void*)parseStatementExpression(tokens);
		if (statement->statement == NULL) {
			*tokens = before;
			statement->kind = .Assign;
			statement->statement = (Void*)parseStatementAssign(tokens);
		};
	};;;;;
	if (statement->statement == NULL) { return NULL; };
	return statement;
};

func parseStatementBlock(tokens: Token***): StatementBlock* {
	expectToken(.OpenCurly);
	var block = newStatementBlock();
	while ((**tokens)->kind != .CloseCurly) {
		var statement = parseStatement(tokens);
		if (statement == NULL) { return NULL; };
		append((Void***)&block->statements, (Void*)statement);
	};
	expectToken(.CloseCurly);
	return block;
};
