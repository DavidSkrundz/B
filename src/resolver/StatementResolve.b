func resolveStatementExpression(statement: StatementExpression*, expectedType: Type*) {
	resolveExpression(statement->expression, NULL);
};

func resolveStatementAssign(statement: StatementAssign*, expectedType: Type*) {
	var lhs = resolveExpression(statement->lhs, NULL);
	resolveExpression(statement->rhs, lhs);
};

func resolveStatementVar(statement: StatementVar*, expectedType: Type*) {
	resolveDeclaration(statement->declaration, false);
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

func resolveStatementReturn(stmt: Statement*, statement: StatementReturn*, expectedType: Type*) {
	if (statement->expression != NULL) {
		resolveExpression(statement->expression, expectedType);
	} else {
		if (expectedType != TypeVoid) {
			ResolverError(stmt->pos, "missing return value", "", "");
		};
	};
};

func resolveStatement(statement: Statement*, expectedType: Type*) {
	if (statement->kind == .Block) {
		resolveStatementBlock((StatementBlock*)statement->statement, expectedType);
	} else if (statement->kind == .Expression) {
		resolveStatementExpression((StatementExpression*)statement->statement, expectedType);
	} else if (statement->kind == .Assign) {
		resolveStatementAssign((StatementAssign*)statement->statement, expectedType);
	} else if (statement->kind == .Var) {
		resolveStatementVar((StatementVar*)statement->statement, expectedType);
	} else if (statement->kind == .If) {
		resolveStatementIf((StatementIf*)statement->statement, expectedType);
	} else if (statement->kind == .While) {
		resolveStatementWhile((StatementWhile*)statement->statement, expectedType);
	} else if (statement->kind == .Return) {
		resolveStatementReturn(statement, (StatementReturn*)statement->statement, expectedType);
	} else {
		ProgrammingError("called resolveStatement on a .Invalid");
	};;;;;;;
};

func resolveStatementBlock(block: StatementBlock*, expectedType: Type*) {
	pushContext();
	var i = 0;
	while (i < Buffer_getCount((Void**)block->statements)) {
		resolveStatement(block->statements[i], expectedType);
		i = i + 1;
	};
	popContext();
};
