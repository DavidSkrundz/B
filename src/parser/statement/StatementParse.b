func expectStatementIf(): StatementIf* {
	expectKeyword(Keyword_If);
	var statement = newStatementIf();
	expectToken(.OpenParenthesis);
	statement->condition = expectExpression();
	expectToken(.CloseParenthesis);
	statement->block = expectStatementBlock();
	if (checkKeyword(Keyword_Else)) {
		if (isTokenKeyword(Keyword_If) || (*_tokens)->kind == .OpenCurly) {
			statement->elseBlock = expectStatement();
		} else { ParserErrorTmp("expecting if or block"); };
	};
	expectToken(.Semicolon);
	return statement;
};

func expectStatementWhile(): StatementWhile* {
	expectKeyword(Keyword_While);
	var statement = newStatementWhile();
	expectToken(.OpenParenthesis);
	statement->condition = expectExpression();
	expectToken(.CloseParenthesis);
	statement->block = expectStatementBlock();
	expectToken(.Semicolon);
	return statement;
};

func expectStatementReturn(): StatementReturn* {
	expectKeyword(Keyword_Return);
	var statement = newStatementReturn();
	if (checkToken(.Semicolon) == false) {
		statement->expression = expectExpression();
		expectToken(.Semicolon);
	};
	return statement;
};

func expectStatementVar(): StatementVar* {
	var statement = newStatementVar();
	statement->declaration = expectDeclaration();
	if (statement->declaration->kind != .Var) { ParserErrorTmp("expecting var declaration"); };
	return statement;
};

func parseStatementExpression(): StatementExpression* {
	var expression = newStatementExpression();
	expression->expression = expectExpression();
	if (checkToken(.Semicolon)) {
		return expression;
	};
	return NULL;
};

func expectStatementAssign(): StatementAssign* {
	var statement = newStatementAssign();
	statement->lhs = expectExpression();
	expectToken(.Assign);
	statement->rhs = expectExpression();
	expectToken(.Semicolon);
	return statement;
};

func expectStatement(): Statement* {
	var statement = newStatement();
	statement->pos = _tokens[0]->pos;
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
		statement->statement = (Void*)expectStatementVar();
	} else if ((*_tokens)->kind == .OpenCurly) {
		statement->kind = .Block;
		statement->statement = (Void*)expectStatementBlock();
	} else {
		var before = _tokens;
		statement->kind = .Expression;
		statement->statement = (Void*)parseStatementExpression();
		if (statement->statement == NULL) {
			_tokens = before;
			statement->kind = .Assign;
			statement->statement = (Void*)expectStatementAssign();
		};
	};;;;;
	return statement;
};

func expectStatementBlock(): StatementBlock* {
	expectToken(.OpenCurly);
	var block = newStatementBlock();
	while ((*_tokens)->kind != .CloseCurly) {
		var statement = expectStatement();
		Buffer_append((Void***)&block->statements, (Void*)statement);
	};
	expectToken(.CloseCurly);
	return block;
};
