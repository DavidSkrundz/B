#include "Statement.h"

#include "../../utility/Memory.h"

Statement* newStatement(void) {
	return xcalloc(1, sizeof(Statement));
}

StatementBlock* newStatementBlock(void) {
	return xcalloc(1, sizeof(StatementBlock));
}

StatementExpression* newStatementExpression(void) {
	return xcalloc(1, sizeof(StatementExpression));
}

StatementAssign* newStatementAssign(void) {
	return xcalloc(1, sizeof(StatementAssign));
}

StatementIf* newStatementIf(void) {
	return xcalloc(1, sizeof(StatementIf));
}

StatementWhile* newStatementWhile(void) {
	return xcalloc(1, sizeof(StatementWhile));
}

StatementReturn* newStatementReturn(void) {
	return xcalloc(1, sizeof(StatementReturn));
}

StatementVar* newStatementVar(void) {
	return xcalloc(1, sizeof(StatementVar));
}
