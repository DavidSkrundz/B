func printStatementExpression(statement: StatementExpression*) {
	printExpression(statement->expression);
};

func printStatementAssign(statement: StatementAssign*) {
	printf((char*)"(assign%c", 10);
	depth = depth + 1;
	printDepth();
	printExpression(statement->lhs);
	printf((char*)"%c", 10);
	printDepth();
	printExpression(statement->rhs);
	printf((char*)"%c", 10);
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
	printf((char*)"%c", 10);
	printDepth();
	printStatementBlock(statement->block);
	printf((char*)"%c", 10);
	if (statement->elseBlock != NULL) {
		printDepth();
		printStatement(statement->elseBlock);
		printf((char*)"%c", 10);
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printStatementWhile(statement: StatementWhile*) {
	printf((char*)"(while ");
	depth = depth + 1;
	printExpression(statement->condition);
	printf((char*)"%c", 10);
	printDepth();
	printStatementBlock(statement->block);
	printf((char*)"%c", 10);
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
	if (statement->kind == StatementKind_Block) {
		printStatementBlock((StatementBlock*)statement->statement);
	} else if (statement->kind == StatementKind_Expression) {
		printStatementExpression((StatementExpression*)statement->statement);
	} else if (statement->kind == StatementKind_Assign) {
		printStatementAssign((StatementAssign*)statement->statement);
	} else if (statement->kind == StatementKind_Var) {
		printStatementVar((StatementVar*)statement->statement);
	} else if (statement->kind == StatementKind_If) {
		printStatementIf((StatementIf*)statement->statement);
	} else if (statement->kind == StatementKind_While) {
		printStatementWhile((StatementWhile*)statement->statement);
	} else if (statement->kind == StatementKind_Return) {
		printStatementReturn((StatementReturn*)statement->statement);
	} else {
		fprintf(stderr, (char*)"Invalid statement kind %zu%c", statement->kind, 10);
		abort();
	};;;;;;;
};

func printStatementBlock(block: StatementBlock*) {
	printf((char*)"(block%c", 10);
	depth = depth + 1;
	var i = 0;
	while (i < block->count) {
		printDepth();
		printStatement(block->statements[i]);
		printf((char*)"%c", 10);
		i = i + 1;
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};
