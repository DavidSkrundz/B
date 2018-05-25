struct Statement {
	var kind: UInt;
	var statement: Void*;
};

struct StatementBlock {
	var statements: Statement**;
	var count: UInt;
};

struct StatementExpression {
	var expression: Expression*;
};

struct StatementAssign {
	var lhs: Expression*;
	var rhs: Expression*;
};

struct StatementIf {
	var condition: Expression*;
	var block: StatementBlock*;
	var elseBlock: Statement*;
};

struct StatementWhile {
	var condition: Expression*;
	var block: StatementBlock*;
};

struct StatementReturn {
	var expression: Expression*;
};

struct StatementVar {
	var declaration: Declaration*;
};

func newStatement(): Statement* {
	return (Statement*)xcalloc((UInt)1, sizeof(Statement));
};

func newStatementBlock(): StatementBlock* {
	return (StatementBlock*)xcalloc((UInt)1, sizeof(StatementBlock));
};

func newStatementExpression(): StatementExpression* {
	return (StatementExpression*)xcalloc((UInt)1, sizeof(StatementExpression));
};

func newStatementAssign(): StatementAssign* {
	return (StatementAssign*)xcalloc((UInt)1, sizeof(StatementAssign));
};

func newStatementIf(): StatementIf* {
	return (StatementIf*)xcalloc((UInt)1, sizeof(StatementIf));
};

func newStatementWhile(): StatementWhile* {
	return (StatementWhile*)xcalloc((UInt)1, sizeof(StatementWhile));
};

func newStatementReturn(): StatementReturn* {
	return (StatementReturn*)xcalloc((UInt)1, sizeof(StatementReturn));
};

func newStatementVar(): StatementVar* {
	return (StatementVar*)xcalloc((UInt)1, sizeof(StatementVar));
};