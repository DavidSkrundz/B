#include "DeclarationParse.h"

#include <stdio.h>
#include <stdlib.h>

#include "../../lexer/token/TokenKind.h"
#include "DeclarationKind.h"
#include "DeclarationState.h"
#include "../expression/ExpressionParse.h"
#include "../attribute/AttributeParse.h"
#include "../identifier/IdentifierParse.h"
#include "../typespec/TypespecParse.h"
#include "../statement/StatementParse.h"
#include "../../utility/Memory.h"

DeclarationVar* parseDeclarationVar(Token*** tokens, Declaration* declaration) {
	if ((**tokens)->kind != TokenKind_Var) { return NULL; }
	++(*tokens);
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; }
	DeclarationVar* decl = newDeclarationVar();
	if ((**tokens)->kind == TokenKind_Colon) {
		++(*tokens);
		decl->type = parseTypespec(tokens);
	}
	if ((**tokens)->kind == TokenKind_Assign) {
		++(*tokens);
		decl->value = parseExpression(tokens);
	}
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; }
	++(*tokens);
	if (decl->type == NULL && decl->value == NULL) { return NULL; }
	return decl;
}

int MAX_STRUCT_FIELD_COUNT = 100;
DeclarationStructFields* parseDeclarationStructFields(Token*** tokens) {
	if ((**tokens)->kind != TokenKind_OpenCurly) { return NULL; }
	++(*tokens);
	DeclarationStructFields* fields = newDeclarationStructFields();
	fields->fields = xcalloc(MAX_STRUCT_FIELD_COUNT, sizeof(Declaration*));
	fields->count = 0;
	while ((**tokens)->kind != TokenKind_CloseCurly) {
		if (fields->count >= MAX_STRUCT_FIELD_COUNT) {
			fprintf(stderr, "Too many fields in struct\n");
			exit(EXIT_FAILURE);
		}
		Declaration* varDecl = parseDeclaration(tokens);
		if (varDecl == NULL) { return NULL; }
		if (varDecl->kind != DeclarationKind_Var) { return NULL; }
		fields->fields[fields->count++] = varDecl;
	}
	return fields;
}

DeclarationFuncArg* parseDeclarationFuncArgument(Token*** tokens) {
	DeclarationFuncArg* arg = newDeclarationFuncArg();
	arg->name = parseIdentifier(tokens);
	if (arg->name == NULL) { return NULL; }
	if ((**tokens)->kind != TokenKind_Colon) { return NULL; }
	++(*tokens);
	arg->type = parseTypespec(tokens);
	if (arg->type == NULL) { return NULL; }
	return arg;
}

int MAX_FUNC_ARGUMENT_COUNT = 10;
DeclarationFuncArgs* parseDeclarationFuncArguments(Token*** tokens) {
	if ((**tokens)->kind != TokenKind_OpenParenthesis) { return NULL; }
	DeclarationFuncArgs* args = newDeclarationFuncArgs();
	args->args = xcalloc(MAX_FUNC_ARGUMENT_COUNT, sizeof(DeclarationFuncArg*));
	args->count = 0;
	do {
		++(*tokens);
		if (args->count >= MAX_FUNC_ARGUMENT_COUNT) {
			fprintf(stderr, "Too many arguments in func\n");
			exit(EXIT_FAILURE);
		}
		DeclarationFuncArg* arg = parseDeclarationFuncArgument(tokens);
		if (arg == NULL) { break; }
		args->args[args->count++] = arg;
	} while ((**tokens)->kind == TokenKind_Comma);
	if ((**tokens)->kind == TokenKind_Ellipses) {
		++(*tokens);
		args->isVariadic = true;
	}
	if ((**tokens)->kind != TokenKind_CloseParenthesis) { return NULL; }
	++(*tokens);
	return args;
}

DeclarationFunc* parseDeclarationFunc(Token*** tokens, Declaration* declaration) {
	if ((**tokens)->kind != TokenKind_Func) { return NULL; }
	++(*tokens);
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; }
	DeclarationFunc* decl = newDeclarationFunc();
	decl->args = parseDeclarationFuncArguments(tokens);
	if (decl->args == NULL) { return NULL; }
	if ((**tokens)->kind == TokenKind_Colon) {
		++(*tokens);
		decl->returnType = parseTypespec(tokens);
		if (decl->returnType == NULL) { return NULL; }
	}
	if ((**tokens)->kind == TokenKind_OpenCurly) {
		decl->block = parseStatementBlock(tokens);
		if (decl->block == NULL) { return NULL; }
	}
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; }
	++(*tokens);
	return decl;
}

DeclarationStruct* parseDeclarationStruct(Token*** tokens, Declaration* declaration) {
	if ((**tokens)->kind != TokenKind_Struct) { return NULL; }
	++(*tokens);
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; }
	DeclarationStruct* decl = newDeclarationStruct();
	if ((**tokens)->kind == TokenKind_OpenCurly) {
		decl->fields = parseDeclarationStructFields(tokens);
		if (decl->fields == NULL) { return NULL; }
		if ((**tokens)->kind != TokenKind_CloseCurly) { return NULL; }
		++(*tokens);
	}
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; }
	++(*tokens);
	return decl;
}

Declaration* parseDeclaration(Token*** tokens) {
	Declaration* declaration = newDeclaration();
	declaration->attribute = parseAttribute(tokens);
	declaration->state = DeclarationState_Unresolved;
	if ((**tokens)->kind == TokenKind_Var) {
		declaration->kind = DeclarationKind_Var;
		declaration->declaration = parseDeclarationVar(tokens, declaration);
	} else if ((**tokens)->kind == TokenKind_Func) {
		declaration->kind = DeclarationKind_Func;
		declaration->declaration = parseDeclarationFunc(tokens, declaration);
	} else if ((**tokens)->kind == TokenKind_Struct) {
		declaration->kind = DeclarationKind_Struct;
		declaration->declaration = parseDeclarationStruct(tokens, declaration);
	}
	if (declaration->declaration == NULL) { return NULL; }
	return declaration;
}
