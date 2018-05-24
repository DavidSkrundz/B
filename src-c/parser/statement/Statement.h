#pragma once

#include "../expression/Expression.h"

typedef struct {
	int kind;
	void* statement;
} Statement;

typedef struct {
	Statement** statements;
	int count;
} StatementBlock;

typedef struct {
	Expression* expression;
} StatementExpression;

typedef struct {
	Expression* lhs;
	Expression* rhs;
} StatementAssign;

typedef struct {
	Expression* condition;
	StatementBlock* block;
	Statement* elseBlock;
} StatementIf;

typedef struct {
	Expression* condition;
	StatementBlock* block;
} StatementWhile;

typedef struct {
	Expression* expression;
} StatementReturn;

typedef struct Declaration Declaration;
typedef struct {
	Declaration* declaration;
} StatementVar;

Statement* newStatement(void);
StatementBlock* newStatementBlock(void);
StatementExpression* newStatementExpression(void);
StatementAssign* newStatementAssign(void);
StatementIf* newStatementIf(void);
StatementWhile* newStatementWhile(void);
StatementReturn* newStatementReturn(void);
StatementVar* newStatementVar(void);
