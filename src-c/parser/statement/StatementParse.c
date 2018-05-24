#include "StatementParse.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "StatementKind.h"
#include "../identifier/IdentifierParse.h"
#include "../expression/ExpressionParse.h"
#include "../../lexer/token/TokenKind.h"
#include "../../parser/declaration/DeclarationParse.h"
#include "../../parser/declaration/DeclarationKind.h"
#include "../../utility/Memory.h"

Statement* parseStatement(Token*** tokens);
StatementIf* parseStatementIf(Token*** tokens) {
	if ((**tokens)->kind != TokenKind_If) { return NULL; }
	++(*tokens);
	StatementIf* statement = newStatementIf();
	if ((**tokens)->kind != TokenKind_OpenParenthesis) { return NULL; }
	++(*tokens);
	statement->condition = parseExpression(tokens);
	if (statement->condition == NULL) { return NULL; }
	if ((**tokens)->kind != TokenKind_CloseParenthesis) { return NULL; }
	++(*tokens);
	statement->block = parseStatementBlock(tokens);
	if (statement->block == NULL) { return NULL; }
	if ((**tokens)->kind == TokenKind_Else) {
		++(*tokens);
		if ((**tokens)->kind == TokenKind_If || (**tokens)->kind == TokenKind_OpenCurly) {
			statement->elseBlock = parseStatement(tokens);
			if (statement->elseBlock == NULL) { return NULL; }
		} else { return NULL; }
	}
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; }
	++(*tokens);
	return statement;
}

StatementWhile* parseStatementWhile(Token*** tokens) {
	if ((**tokens)->kind != TokenKind_While) { return NULL; }
	++(*tokens);
	StatementWhile* statement = newStatementWhile();
	if ((**tokens)->kind != TokenKind_OpenParenthesis) { return NULL; }
	++(*tokens);
	statement->condition = parseExpression(tokens);
	if (statement->condition == NULL) { return NULL; }
	if ((**tokens)->kind != TokenKind_CloseParenthesis) { return NULL; }
	++(*tokens);
	statement->block = parseStatementBlock(tokens);
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; }
	++(*tokens);
	return statement;
}

StatementReturn* parseStatementReturn(Token*** tokens) {
	if ((**tokens)->kind != TokenKind_Return) { return NULL; }
	++(*tokens);
	StatementReturn* statement = newStatementReturn();
	statement->expression = parseExpression(tokens);
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; }
	++(*tokens);
	return statement;
}

StatementVar* parseStatementVar(Token*** tokens) {
	StatementVar* statement = newStatementVar();
	statement->declaration = parseDeclaration(tokens);
	if (statement->declaration == NULL) { return NULL; }
	if (statement->declaration->kind != DeclarationKind_Var) { return NULL; }
	return statement;
}

StatementExpression* parseStatementExpression(Token*** tokens) {
	StatementExpression* expression = newStatementExpression();
	expression->expression = parseExpression(tokens);
	if (expression->expression == NULL) { return NULL; }
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; }
	++(*tokens);
	return expression;
}

StatementAssign* parseStatementAssign(Token*** tokens) {
	StatementAssign* statement = newStatementAssign();
	statement->lhs = parseExpression(tokens);
	if ((**tokens)->kind != TokenKind_Assign) { return NULL; }
	++(*tokens);
	statement->rhs = parseExpression(tokens);
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; }
	++(*tokens);
	return statement;
}

Statement* parseStatement(Token*** tokens) {
	Statement* statement = newStatement();
	if ((**tokens)->kind == TokenKind_If) {
		statement->kind = StatementKind_If;
		statement->statement = parseStatementIf(tokens);
	} else if ((**tokens)->kind == TokenKind_While) {
		statement->kind = StatementKind_While;
		statement->statement = parseStatementWhile(tokens);
	} else if ((**tokens)->kind == TokenKind_Return) {
		statement->kind = StatementKind_Return;
		statement->statement = parseStatementReturn(tokens);
	} else if ((**tokens)->kind == TokenKind_Var) {
		statement->kind = StatementKind_Var;
		statement->statement = parseStatementVar(tokens);
	} else if ((**tokens)->kind == TokenKind_OpenCurly) {
		statement->kind = StatementKind_Block;
		statement->statement = parseStatementBlock(tokens);
	} else {
		Token** before = *tokens;
		statement->kind = StatementKind_Expression;
		statement->statement = parseStatementExpression(tokens);
		if (statement->statement == NULL) {
			*tokens = before;
			statement->kind = StatementKind_Assign;
			statement->statement = parseStatementAssign(tokens);
		}
	}
	if (statement->statement == NULL) { return NULL; }
	return statement;
}

int MAX_STATEMENT_BLOCK_SIZE = 100;
StatementBlock* parseStatementBlock(Token*** tokens) {
	if ((**tokens)->kind != TokenKind_OpenCurly) { return NULL; }
	++(*tokens);
	StatementBlock* block = newStatementBlock();
	block->statements = xcalloc(MAX_STATEMENT_BLOCK_SIZE, sizeof(Statement*));
	block->count = 0;
	while ((**tokens)->kind != TokenKind_CloseCurly) {
		if (block->count >= MAX_STATEMENT_BLOCK_SIZE) {
			fprintf(stderr, "Too many statements in block\n");
			exit(EXIT_FAILURE);
		}
		Statement* statement = parseStatement(tokens);
		if (statement == NULL) { return NULL; }
		block->statements[block->count++] = statement;
	}
	if ((**tokens)->kind != TokenKind_CloseCurly) { return NULL; }
	++(*tokens);
	return block;
}
