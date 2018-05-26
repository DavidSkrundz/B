func parseStatementIf(tokens: Token***): StatementIf* {
	expectToken(TokenKind_If);
	var statement = newStatementIf();
	expectToken(TokenKind_OpenParenthesis);
	statement->condition = parseExpression(tokens);
	if (statement->condition == NULL) { return NULL; };
	expectToken(TokenKind_CloseParenthesis);
	statement->block = parseStatementBlock(tokens);
	if (statement->block == NULL) { return NULL; };
	if (checkToken(TokenKind_Else)) {
		if ((**tokens)->kind == TokenKind_If || (**tokens)->kind == TokenKind_OpenCurly) {
			statement->elseBlock = parseStatement(tokens);
			if (statement->elseBlock == NULL) { return NULL; };
		} else { return NULL; };
	};
	expectToken(TokenKind_Semicolon);
	return statement;
};

func parseStatementWhile(tokens: Token***): StatementWhile* {
	expectToken(TokenKind_While);
	var statement = newStatementWhile();
	expectToken(TokenKind_OpenParenthesis);
	statement->condition = parseExpression(tokens);
	if (statement->condition == NULL) { return NULL; };
	expectToken(TokenKind_CloseParenthesis);
	statement->block = parseStatementBlock(tokens);
	expectToken(TokenKind_Semicolon);
	return statement;
};

func parseStatementReturn(tokens: Token***): StatementReturn* {
	expectToken(TokenKind_Return);
	var statement = newStatementReturn();
	statement->expression = parseExpression(tokens);
	expectToken(TokenKind_Semicolon);
	return statement;
};

func parseStatementVar(tokens: Token***): StatementVar* {
	var statement = newStatementVar();
	statement->declaration = parseDeclaration(tokens);
	if (statement->declaration == NULL) { return NULL; };
	if (statement->declaration->kind != DeclarationKind_Var) { return NULL; };
	return statement;
};

func parseStatementExpression(tokens: Token***): StatementExpression* {
	var expression = newStatementExpression();
	expression->expression = parseExpression(tokens);
	if (expression->expression == NULL) { return NULL; };
	if (checkToken(TokenKind_Semicolon)) {
		return expression;
	};
	return NULL;
};

func parseStatementAssign(tokens: Token***): StatementAssign* {
	var statement = newStatementAssign();
	statement->lhs = parseExpression(tokens);
	expectToken(TokenKind_Assign);
	statement->rhs = parseExpression(tokens);
	expectToken(TokenKind_Semicolon);
	return statement;
};

func parseStatement(tokens: Token***): Statement* {
	var statement = newStatement();
	if ((**tokens)->kind == TokenKind_If) {
		statement->kind = StatementKind_If;
		statement->statement = (Void*)parseStatementIf(tokens);
	} else if ((**tokens)->kind == TokenKind_While) {
		statement->kind = StatementKind_While;
		statement->statement = (Void*)parseStatementWhile(tokens);
	} else if ((**tokens)->kind == TokenKind_Return) {
		statement->kind = StatementKind_Return;
		statement->statement = (Void*)parseStatementReturn(tokens);
	} else if ((**tokens)->kind == TokenKind_Var) {
		statement->kind = StatementKind_Var;
		statement->statement = (Void*)parseStatementVar(tokens);
	} else if ((**tokens)->kind == TokenKind_OpenCurly) {
		statement->kind = StatementKind_Block;
		statement->statement = (Void*)parseStatementBlock(tokens);
	} else {
		var before = *tokens;
		statement->kind = StatementKind_Expression;
		statement->statement = (Void*)parseStatementExpression(tokens);
		if (statement->statement == NULL) {
			*tokens = before;
			statement->kind = StatementKind_Assign;
			statement->statement = (Void*)parseStatementAssign(tokens);
		};
	};;;;;
	if (statement->statement == NULL) { return NULL; };
	return statement;
};

var MAX_STATEMENT_BLOCK_SIZE = 100;
func parseStatementBlock(tokens: Token***): StatementBlock* {
	expectToken(TokenKind_OpenCurly);
	var block = newStatementBlock();
	block->statements = (Statement**)xcalloc(MAX_STATEMENT_BLOCK_SIZE, sizeof(Statement*));
	block->count = 0;
	while ((**tokens)->kind != TokenKind_CloseCurly) {
		if (MAX_STATEMENT_BLOCK_SIZE < block->count) {
			fprintf(stderr, (char*)"Too many statements in block%c", 10);
			exit(EXIT_FAILURE);
		};
		var statement = parseStatement(tokens);
		if (statement == NULL) { return NULL; };
		block->statements[block->count] = statement;
		block->count = block->count + 1;
	};
	expectToken(TokenKind_CloseCurly);
	return block;
};
