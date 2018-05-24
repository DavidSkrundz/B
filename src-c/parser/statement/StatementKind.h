#pragma once

extern int StatementKind_Invalid;
extern int StatementKind_Block;
extern int StatementKind_Expression;
extern int StatementKind_Assign;

extern int StatementKind_Var;
extern int StatementKind_If;
extern int StatementKind_While;
extern int StatementKind_Return;

void InitStatementKinds(void);
