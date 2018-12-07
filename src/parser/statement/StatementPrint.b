func printStatementExpression(statement: StatementExpression*) {
	printExpression(statement->expression);
};

func printStatementAssign(statement: StatementAssign*) {
	printf((char*)"(assign\n");
	depth = depth + 1;
	printDepth();
	printExpression(statement->lhs);
	printf((char*)"\n");
	printDepth();
	printExpression(statement->rhs);
	printf((char*)"\n");
	printDepth();
	depth = depth - 1;
	printf((char*)")");
};

func printStatementVar(statement: StatementVar*) {
	printDeclaration(statement->declaration);
};

func printStatementIf(statement: StatementIf*) {
	printf((char*)"(if ");
	depth = depth + 1;
	printExpression(statement->condition);
	printf((char*)"\n");
	printDepth();
	printStatementBlock(statement->block);
	printf((char*)"\n");
	if (statement->elseBlock != NULL) {
		printDepth();
		printStatement(statement->elseBlock);
		printf((char*)"\n");
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printStatementWhile(statement: StatementWhile*) {
	printf((char*)"(while ");
	depth = depth + 1;
	printExpression(statement->condition);
	printf((char*)"\n");
	printDepth();
	printStatementBlock(statement->block);
	printf((char*)"\n");
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printStatementReturn(statement: StatementReturn*) {
	printf((char*)"(return");
	if (statement->expression != NULL) {
		printf((char*)" ");
		printExpression(statement->expression);
	};
	printf((char*)")");
};

func printStatement(statement: Statement*) {
	if (statement->kind == .Block) {
		printStatementBlock((StatementBlock*)statement->statement);
	} else if (statement->kind == .Expression) {
		printStatementExpression((StatementExpression*)statement->statement);
	} else if (statement->kind == .Assign) {
		printStatementAssign((StatementAssign*)statement->statement);
	} else if (statement->kind == .Var) {
		printStatementVar((StatementVar*)statement->statement);
	} else if (statement->kind == .If) {
		printStatementIf((StatementIf*)statement->statement);
	} else if (statement->kind == .While) {
		printStatementWhile((StatementWhile*)statement->statement);
	} else if (statement->kind == .Return) {
		printStatementReturn((StatementReturn*)statement->statement);
	} else if (statement->kind == .Invalid) {
		fprintf(stderr, (char*)"Invalid statement kind %u\n", statement->kind);
		Abort();
	} else {
		fprintf(stderr, (char*)"Invalid statement kind %u\n", statement->kind);
		Abort();
	};;;;;;;;
};

func printStatementBlock(block: StatementBlock*) {
	printf((char*)"(block\n");
	depth = depth + 1;
	var i = 0;
	while (i < Buffer_getCount((Void**)block->statements)) {
		printDepth();
		printStatement(block->statements[i]);
		printf((char*)"\n");
		i = i + 1;
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};
