func resolveStatementExpression(statement: StatementExpression*, expectedType: Type*) {
	resolveExpression(statement->expression, NULL);
};

func resolveStatementAssign(statement: StatementAssign*, expectedType: Type*) {
	var lhs = resolveExpression(statement->lhs, NULL);
	resolveExpression(statement->rhs, lhs);
};

func resolveStatementVar(statement: StatementVar*, expectedType: Type*) {
	resolveDeclarationType((Declaration*)statement->declaration);
	resolveDeclarationDefinition(statement->declaration);
};

func resolveStatementIf(statement: StatementIf*, expectedType: Type*) {
	resolveExpression(statement->condition, TypeBool);
	resolveStatementBlock(statement->block, expectedType);
	if (statement->elseBlock != NULL) {
		resolveStatement(statement->elseBlock, expectedType);
	};
};

func resolveStatementWhile(statement: StatementWhile*, expectedType: Type*) {
	resolveExpression(statement->condition, TypeBool);
	resolveStatementBlock(statement->block, expectedType);
};

func resolveStatementReturn(statement: StatementReturn*, expectedType: Type*) {
	if (statement->expression != NULL) {
		resolveExpression(statement->expression, expectedType);
	} else {
		if (expectedType != TypeVoid) {
			fprintf(stderr, (char*)"Return missing value%c", 10);
			exit(EXIT_FAILURE);
		};
	};
};

func resolveStatement(statement: Statement*, expectedType: Type*) {
	if (statement->kind == StatementKind_Block) {
		resolveStatementBlock((StatementBlock*)statement->statement, expectedType);
	} else if (statement->kind == StatementKind_Expression) {
		resolveStatementExpression((StatementExpression*)statement->statement, expectedType);
	} else if (statement->kind == StatementKind_Assign) {
		resolveStatementAssign((StatementAssign*)statement->statement, expectedType);
	} else if (statement->kind == StatementKind_Var) {
		resolveStatementVar((StatementVar*)statement->statement, expectedType);
	} else if (statement->kind == StatementKind_If) {
		resolveStatementIf((StatementIf*)statement->statement, expectedType);
	} else if (statement->kind == StatementKind_While) {
		resolveStatementWhile((StatementWhile*)statement->statement, expectedType);
	} else if (statement->kind == StatementKind_Return) {
		resolveStatementReturn((StatementReturn*)statement->statement, expectedType);
	} else {
		fprintf(stderr, (char*)"Invalid statement kind %zu%c", statement->kind, 10);
		abort();
	};;;;;;;
};

func resolveStatementBlock(block: StatementBlock*, expectedType: Type*) {
	var oldContextCount = _context->count;
	var i = (UInt)0;
	while (i < block->count) {
		resolveStatement(block->statements[i], expectedType);
		i = i + (UInt)1;
	};
	_context->count = oldContextCount;
};
