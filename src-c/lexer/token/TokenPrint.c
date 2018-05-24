#include "TokenPrint.h"

#include <stdio.h>
#include <stdlib.h>

#include "TokenKind.h"

void _printToken(Token* token, FILE* stream) {
	if (token == NULL) {
		fprintf(stderr, "NULL Token");
		abort();
	}
	if (token->kind == TokenKind_EOF) {
		fprintf(stream, "EOF");
	} else if (token->kind == TokenKind_NULL) {
		fprintf(stream, "NULL");
	} else if (token->kind == TokenKind_Sizeof) {
		fprintf(stream, "SIZEOF");
	} else if (token->kind == TokenKind_Struct) {
		fprintf(stream, "STRUCT");
	} else if (token->kind == TokenKind_Var) {
		fprintf(stream, "VAR");
	} else if (token->kind == TokenKind_Func) {
		fprintf(stream, "FUNC");
	} else if (token->kind == TokenKind_If) {
		fprintf(stream, "IF");
	} else if (token->kind == TokenKind_Else) {
		fprintf(stream, "ELSE");
	} else if (token->kind == TokenKind_While) {
		fprintf(stream, "WHILE");
	} else if (token->kind == TokenKind_Return) {
		fprintf(stream, "RETURN");
	} else if (token->kind == TokenKind_Comma) {
		fprintf(stream, "COMMA (,)");
	} else if (token->kind == TokenKind_Colon) {
		fprintf(stream, "COLON (:)");
	} else if (token->kind == TokenKind_Semicolon) {
		fprintf(stream, "SEMICOLON (;)");
	} else if (token->kind == TokenKind_OpenCurly) {
		fprintf(stream, "OPENCURLY ({)");
	} else if (token->kind == TokenKind_CloseCurly) {
		fprintf(stream, "CLOSECURLY (})");
	} else if (token->kind == TokenKind_OpenBracket) {
		fprintf(stream, "OPENBRACKET ([)");
	} else if (token->kind == TokenKind_CloseBracket) {
		fprintf(stream, "CLOSEBRACKET (])");
	} else if (token->kind == TokenKind_OpenParenthesis) {
		fprintf(stream, "OPENPARENTHESIS (()");
	} else if (token->kind == TokenKind_CloseParenthesis) {
		fprintf(stream, "CLOSEPARENTHESIS ())");
	} else if (token->kind == TokenKind_At) {
		fprintf(stream, "AT (@)");
	} else if (token->kind == TokenKind_Star) {
		fprintf(stream, "STAR (*)");
	} else if (token->kind == TokenKind_And) {
		fprintf(stream, "AND (&)");
	} else if (token->kind == TokenKind_AndAnd) {
		fprintf(stream, "AND (&&)");
	} else if (token->kind == TokenKind_OrOr) {
		fprintf(stream, "OR (||)");
	} else if (token->kind == TokenKind_Plus) {
		fprintf(stream, "PLUS (+)");
	} else if (token->kind == TokenKind_Minus) {
		fprintf(stream, "MINUS (-)");
	} else if (token->kind == TokenKind_Slash) {
		fprintf(stream, "SLASH (/)");
	} else if (token->kind == TokenKind_And) {
		fprintf(stream, "AND (&)");
	} else if (token->kind == TokenKind_Not) {
		fprintf(stream, "NOT (!)");
	} else if (token->kind == TokenKind_Assign) {
		fprintf(stream, "ASSIGN (=)");
	} else if (token->kind == TokenKind_Ellipses) {
		fprintf(stream, "ELLIPSES (...)");
	} else if (token->kind == TokenKind_Arrow) {
		fprintf(stream, "ARROW (->)");
	} else if (token->kind == TokenKind_Equal) {
		fprintf(stream, "EQUAL (==)");
	} else if (token->kind == TokenKind_LessThan) {
		fprintf(stream, "LESSTHAN (<)");
	} else if (token->kind == TokenKind_NotEqual) {
		fprintf(stream, "NOTEQUAL (!=)");
	} else if (token->kind == TokenKind_Identifier) {
		fprintf(stream, "IDENTIFIER (%.*s)", token->length, token->value);
	} else if (token->kind == TokenKind_BooleanLiteral) {
		fprintf(stream, "BOOLEAN (%.*s)", token->length, token->value);
	} else if (token->kind == TokenKind_IntegerLiteral) {
		fprintf(stream, "INTEGER (%.*s)", token->length, token->value);
	} else if (token->kind == TokenKind_StringLiteral) {
		fprintf(stream, "STRING (%.*s)", token->length, token->value);
	} else {
		fprintf(stderr, "Unknown token kind: %d", token->kind);
		abort();
	}
}

void printToken(Token* token) { _printToken(token, stdout); }
void printToken_error(Token* token) { _printToken(token, stderr); }

void printTokens(Token** tokens, int length) {
	for (int i = 0; i < length; ++i) {
		printToken(tokens[i]);
		printf("\n");
	}
}
