#include "StatementPrint.h"

#include <stdio.h>
#include <stdlib.h>

#include "../DepthPrint.h"
#include "StatementKind.h"
#include "../expression/ExpressionPrint.h"
#include "../declaration/DeclarationPrint.h"

void printStatementExpression(StatementExpression* statement) {
	printExpression(statement->expression);
}

void printStatementAssign(StatementAssign* statement) {
	printf("(assign\n");
	++depth;
	printDepth();
	printExpression(statement->lhs);
	printf("\n");
	printDepth();
	printExpression(statement->rhs);
	printf("\n");
	printDepth();
	--depth;
	printf(")");
}

void printStatementVar(StatementVar* statement) {
	printDeclaration(statement->declaration);
}

void printStatement(Statement* statement);
void printStatementIf(StatementIf* statement) {
	printf("(if ");
	++depth;
	printExpression(statement->condition);
	printf("\n");
	printDepth();
	printStatementBlock(statement->block);
	printf("\n");
	if (statement->elseBlock != NULL) {
		printDepth();
		printStatement(statement->elseBlock);
		printf("\n");
	}
	--depth;
	printDepth();
	printf(")");
}

void printStatementWhile(StatementWhile* statement) {
	printf("(while ");
	++depth;
	printExpression(statement->condition);
	printf("\n");
	printDepth();
	printStatementBlock(statement->block);
	printf("\n");
	--depth;
	printDepth();
	printf(")");
}

void printStatementReturn(StatementReturn* statement) {
	printf("(return");
	if (statement->expression != NULL) {
		printf(" ");
		printExpression(statement->expression);
	}
	printf(")");
}

void printStatement(Statement* statement) {
	if (statement->kind == StatementKind_Block) {
		printStatementBlock(statement->statement);
	} else if (statement->kind == StatementKind_Expression) {
		printStatementExpression(statement->statement);
	} else if (statement->kind == StatementKind_Assign) {
		printStatementAssign(statement->statement);
	} else if (statement->kind == StatementKind_Var) {
		printStatementVar(statement->statement);
	} else if (statement->kind == StatementKind_If) {
		printStatementIf(statement->statement);
	} else if (statement->kind == StatementKind_While) {
		printStatementWhile(statement->statement);
	} else if (statement->kind == StatementKind_Return) {
		printStatementReturn(statement->statement);
	} else {
		fprintf(stderr, "Invalid statement kind %d\n", statement->kind);
		abort();
	}
}

void printStatementBlock(StatementBlock* block) {
	printf("(block\n");
	++depth;
	for (int i = 0; i < block->count; ++i) {
		printDepth();
		printStatement(block->statements[i]);
		printf("\n");
	}
	--depth;
	printDepth();
	printf(")");
}
