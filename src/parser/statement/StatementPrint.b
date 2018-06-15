func printStatementExpression(statement: StatementExpression*) {
	printExpression(statement->expression);
};

func printStatementAssign(statement: StatementAssign*) {
	printf((char*)"(assign%c", '\n');
	depth = depth + 1;
	printDepth();
	printExpression(statement->lhs);
	printf((char*)"%c", '\n');
	printDepth();
	printExpression(statement->rhs);
	printf((char*)"%c", '\n');
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
	printf((char*)"%c", '\n');
	printDepth();
	printStatementBlock(statement->block);
	printf((char*)"%c", '\n');
	if (statement->elseBlock != NULL) {
		printDepth();
		printStatement(statement->elseBlock);
		printf((char*)"%c", '\n');
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printStatementWhile(statement: StatementWhile*) {
	printf((char*)"(while ");
	depth = depth + 1;
	printExpression(statement->condition);
	printf((char*)"%c", '\n');
	printDepth();
	printStatementBlock(statement->block);
	printf((char*)"%c", '\n');
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
	} else {
		fprintf(stderr, (char*)"Invalid statement kind %u%c", statement->kind, '\n');
		abort();
	};;;;;;;
};

func printStatementBlock(block: StatementBlock*) {
	printf((char*)"(block%c", '\n');
	depth = depth + 1;
	var i = 0;
	while (i < bufferCount((Void**)block->statements)) {
		printDepth();
		printStatement(block->statements[i]);
		printf((char*)"%c", '\n');
		i = i + 1;
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};
