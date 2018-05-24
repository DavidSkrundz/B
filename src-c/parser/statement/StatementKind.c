#include "StatementKind.h"

int StatementKind_Invalid;
int StatementKind_Block;
int StatementKind_Expression;
int StatementKind_Assign;

int StatementKind_Var;
int StatementKind_If;
int StatementKind_While;
int StatementKind_Return;

void InitStatementKinds(void) {
	int counter = 0;
	
	StatementKind_Invalid = counter++;
	StatementKind_Block = counter++;
	StatementKind_Expression = counter++;
	StatementKind_Assign = counter++;
	
	StatementKind_Var = counter++;
	StatementKind_If = counter++;
	StatementKind_While = counter++;
	StatementKind_Return = counter++;
}
