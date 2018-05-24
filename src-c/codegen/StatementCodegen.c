#include "StatementCodegen.h"

#include <stdio.h>
#include <stdlib.h>

#include "../parser/statement/StatementKind.h"
#include "DeclarationCodegen.h"
#include "CodegenDepth.h"
#include "ExpressionCodegen.h"

void codegenStatementExpression(StatementExpression* statement) {
	codegenExpression(statement->expression);
	printf(";\n");
}

void codegenStatementAssign(StatementAssign* statement) {
	codegenExpression(statement->lhs);
	printf(" = ");
	codegenExpression(statement->rhs);
	printf(";\n");
}

void codegenStatementVar(StatementVar* statement) {
	codegenDeclarationDefinition(statement->declaration);
}

void codegenStatement(Statement* statement);
void codegenStatementIf(StatementIf* statement) {
	printf("if ");
	codegenExpression(statement->condition);
	printf(" ");
	codegenStatementBlock(statement->block);
	if (statement->elseBlock != NULL) {
		printf(" else ");
		codegenStatement(statement->elseBlock);
	}
	printf("\n");
}

void codegenStatementWhile(StatementWhile* statement) {
	printf("while ");
	codegenExpression(statement->condition);
	printf(" ");
	codegenStatementBlock(statement->block);
	printf("\n");
}

void codegenStatementReturn(StatementReturn* statement) {
	printf("return");
	if (statement->expression != NULL) {
		printf(" ");
		codegenExpression(statement->expression);
	}
	printf(";\n");
}

void codegenStatement(Statement* statement) {
	if (statement->kind == StatementKind_Block) {
		codegenStatementBlock(statement->statement);
	} else if (statement->kind == StatementKind_Expression) {
		codegenStatementExpression(statement->statement);
	} else if (statement->kind == StatementKind_Assign) {
		codegenStatementAssign(statement->statement);
	} else if (statement->kind == StatementKind_Var) {
		codegenStatementVar(statement->statement);
	} else if (statement->kind == StatementKind_If) {
		codegenStatementIf(statement->statement);
	} else if (statement->kind == StatementKind_While) {
		codegenStatementWhile(statement->statement);
	} else if (statement->kind == StatementKind_Return) {
		codegenStatementReturn(statement->statement);
	} else {
		fprintf(stderr, "Invalid statement kind %d\n", statement->kind);
		abort();
	}
}

void codegenStatementBlock(StatementBlock* block) {
	printf("{\n");
	++genDepth;
	for (int i = 0; i < block->count; ++i) {
		codegenDepth();
		codegenStatement(block->statements[i]);
	}
	--genDepth;
	codegenDepth();
	printf("}");
}
