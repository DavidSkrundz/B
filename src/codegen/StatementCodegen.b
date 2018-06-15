func codegenStatementExpression(statement: StatementExpression*) {
	codegenExpression(statement->expression);
	printf((char*)";\n");
};

func codegenStatementAssign(statement: StatementAssign*) {
	codegenExpression(statement->lhs);
	printf((char*)" = ");
	codegenExpression(statement->rhs);
	printf((char*)";\n");
};

func codegenStatementVar(statement: StatementVar*) {
	codegenDeclarationDefinition(statement->declaration);
};

func codegenStatementIf(statement: StatementIf*) {
	printf((char*)"if ");
	codegenExpression(statement->condition);
	printf((char*)" ");
	codegenStatementBlock(statement->block);
	if (statement->elseBlock != NULL) {
		printf((char*)" else ");
		codegenStatement(statement->elseBlock);
	};
	printf((char*)"\n");
};

func codegenStatementWhile(statement: StatementWhile*) {
	printf((char*)"while ");
	codegenExpression(statement->condition);
	printf((char*)" ");
	codegenStatementBlock(statement->block);
	printf((char*)"\n");
};

func codegenStatementReturn(statement: StatementReturn*) {
	printf((char*)"return");
	if (statement->expression != NULL) {
		printf((char*)" ");
		codegenExpression(statement->expression);
	};
	printf((char*)";\n");
};

func codegenStatement(statement: Statement*) {
	if (statement->kind == .Block) {
		codegenStatementBlock((StatementBlock*)statement->statement);
	} else if (statement->kind == .Expression) {
		codegenStatementExpression((StatementExpression*)statement->statement);
	} else if (statement->kind == .Assign) {
		codegenStatementAssign((StatementAssign*)statement->statement);
	} else if (statement->kind == .Var) {
		codegenStatementVar((StatementVar*)statement->statement);
	} else if (statement->kind == .If) {
		codegenStatementIf((StatementIf*)statement->statement);
	} else if (statement->kind == .While) {
		codegenStatementWhile((StatementWhile*)statement->statement);
	} else if (statement->kind == .Return) {
		codegenStatementReturn((StatementReturn*)statement->statement);
	} else {
		fprintf(stderr, (char*)"Invalid statement kind %u\n", statement->kind);
		abort();
	};;;;;;;
};

func codegenStatementBlock(block: StatementBlock*) {
	printf((char*)"{\n");
	genDepth = genDepth + 1;
	var i = 0;
	while (i < bufferCount((Void**)block->statements)) {
		codegenDepth();
		codegenStatement(block->statements[i]);
		i = i + 1;
	};
	genDepth = genDepth - 1;
	codegenDepth();
	printf((char*)"}");
};
