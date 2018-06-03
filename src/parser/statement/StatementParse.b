func parseStatementIf(tokens: Token***): StatementIf* {
	expectToken(.If);
	var statement = newStatementIf();
	expectToken(.OpenParenthesis);
	statement->condition = parseExpression(tokens);
	if (statement->condition == NULL) { return NULL; };
	expectToken(.CloseParenthesis);
	statement->block = parseStatementBlock(tokens);
	if (statement->block == NULL) { return NULL; };
	if (checkToken(.Else)) {
		if ((**tokens)->kind == .If || (**tokens)->kind == .OpenCurly) {
			statement->elseBlock = parseStatement(tokens);
			if (statement->elseBlock == NULL) { return NULL; };
		} else { return NULL; };
	};
	expectToken(.Semicolon);
	return statement;
};

func parseStatementWhile(tokens: Token***): StatementWhile* {
	expectToken(.While);
	var statement = newStatementWhile();
	expectToken(.OpenParenthesis);
	statement->condition = parseExpression(tokens);
	if (statement->condition == NULL) { return NULL; };
	expectToken(.CloseParenthesis);
	statement->block = parseStatementBlock(tokens);
	expectToken(.Semicolon);
	return statement;
};

func parseStatementReturn(tokens: Token***): StatementReturn* {
	expectToken(.Return);
	var statement = newStatementReturn();
	statement->expression = parseExpression(tokens);
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
	if ((**tokens)->kind == .If) {
		statement->kind = .If;
		statement->statement = (Void*)parseStatementIf(tokens);
	} else if ((**tokens)->kind == .While) {
		statement->kind = .While;
		statement->statement = (Void*)parseStatementWhile(tokens);
	} else if ((**tokens)->kind == .Return) {
		statement->kind = .Return;
		statement->statement = (Void*)parseStatementReturn(tokens);
	} else if ((**tokens)->kind == .Var) {
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
