#include "StatementResolve.h"

#include <stdio.h>
#include <stdlib.h>

#include "../parser/statement/StatementKind.h"
#include "DeclarationResolve.h"
#include "ExpressionResolve.h"
#include "Context.h"
#include "type/TypeBuiltin.h"

void resolveStatementExpression(StatementExpression* statement, Type* expectedType) {
	resolveExpression(statement->expression, NULL);
}

void resolveStatementAssign(StatementAssign* statement, Type* expectedType) {
	Type* lhs = resolveExpression(statement->lhs, NULL);
	resolveExpression(statement->rhs, lhs);
}

void resolveStatementVar(StatementVar* statement, Type* expectedType) {
	resolveDeclarationType(statement->declaration);
	resolveDeclarationDefinition(statement->declaration);
}

void resolveStatement(Statement* statement, Type* expectedType);
void resolveStatementIf(StatementIf* statement, Type* expectedType) {
	resolveExpression(statement->condition, TypeBool);
	resolveStatementBlock(statement->block, expectedType);
	if (statement->elseBlock != NULL) {
		resolveStatement(statement->elseBlock, expectedType);
	}
}

void resolveStatementWhile(StatementWhile* statement, Type* expectedType) {
	resolveExpression(statement->condition, TypeBool);
	resolveStatementBlock(statement->block, expectedType);
}

void resolveStatementReturn(StatementReturn* statement, Type* expectedType) {
	if (statement->expression != NULL) {
		resolveExpression(statement->expression, expectedType);
	} else {
		if (expectedType != TypeVoid) {
			fprintf(stderr, "Return missing value\n");
			exit(EXIT_FAILURE);
		}
	}
}

void resolveStatement(Statement* statement, Type* expectedType) {
	if (statement->kind == StatementKind_Block) {
		resolveStatementBlock(statement->statement, expectedType);
	} else if (statement->kind == StatementKind_Expression) {
		resolveStatementExpression(statement->statement, expectedType);
	} else if (statement->kind == StatementKind_Assign) {
		resolveStatementAssign(statement->statement, expectedType);
	} else if (statement->kind == StatementKind_Var) {
		resolveStatementVar(statement->statement, expectedType);
	} else if (statement->kind == StatementKind_If) {
		resolveStatementIf(statement->statement, expectedType);
	} else if (statement->kind == StatementKind_While) {
		resolveStatementWhile(statement->statement, expectedType);
	} else if (statement->kind == StatementKind_Return) {
		resolveStatementReturn(statement->statement, expectedType);
	} else {
		fprintf(stderr, "Invalid statement kind %d\n", statement->kind);
		abort();
	}
}

extern Context* context;
void resolveStatementBlock(StatementBlock* block, Type* expectedType) {
	int oldContextCount = context->count;
	for (int i = 0; i < block->count; ++i) {
		resolveStatement(block->statements[i], expectedType);
	}
	context->count = oldContextCount;
}
