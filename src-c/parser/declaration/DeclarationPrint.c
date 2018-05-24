#include "DeclarationPrint.h"

#include <stdio.h>
#include <stdlib.h>

#include "../DepthPrint.h"
#include "../attribute/AttributePrint.h"
#include "../identifier/IdentifierPrint.h"
#include "../typespec/TypespecPrint.h"
#include "../expression/ExpressionPrint.h"
#include "../statement/StatementPrint.h"
#include "DeclarationKind.h"

void printDeclarationVar(DeclarationVar* declaration, Identifier* name) {
	printf("(var ");
	printIdentifier(name);
	if (declaration->type != NULL) {
		printf(" ");
		printTypespec(declaration->type);
	}
	if (declaration->value != NULL) {
		printf(" (expression\n");
		++depth;
		++depth;
		printDepth();
		printExpression(declaration->value);
		--depth;
		--depth;
		printf("\n");
		printDepth();
		printf(")");
	}
	printf(")");
}

void printDeclarationStructFields(DeclarationStructFields* fields) {
	printf("(fields\n");
	++depth;
	for (int i = 0; i < fields->count; ++i) {
		printDepth();
		printDeclaration(fields->fields[i]);
		printf("\n");
	}
	--depth;
	printDepth();
	printf(")");
}

void printDeclarationFuncArg(DeclarationFuncArg* arg) {
	printf("(");
	printIdentifier(arg->name);
	printf(" ");
	printTypespec(arg->type);
	printf(")");
}

void printDeclarationFuncArgs(DeclarationFuncArgs* args) {
	printf("(arguments\n");
	++depth;
	for (int i = 0; i < args->count; ++i) {
		printDepth();
		printDeclarationFuncArg(args->args[i]);
		printf("\n");
	}
	if (args->isVariadic) {
		printDepth();
		printf("(...)\n");
	}
	--depth;
	printDepth();
	printf(")");
}

void printDeclarationFunc(DeclarationFunc* declaration, Identifier* name) {
	printf("(func ");
	printIdentifier(name);
	printf(" ");
	if (declaration->returnType == NULL) {
		printf("()");
	} else {
		printTypespec(declaration->returnType);
	}
	printf("\n");
	++depth;
	printDepth();
	printDeclarationFuncArgs(declaration->args);
	printf("\n");
	if (declaration->block != NULL) {
		printDepth();
		printStatementBlock(declaration->block);
		printf("\n");
	}
	--depth;
	printDepth();
	printf(")");
}

void printDeclarationStruct(DeclarationStruct* declaration, Identifier* name) {
	printf("(struct\n");
	++depth;
	printDepth();
	printIdentifier(name);
	printf("\n");
	if (declaration->fields != NULL) {
		printDepth();
		printDeclarationStructFields(declaration->fields);
		printf("\n");
	}
	--depth;
	printDepth();
	printf(")");
}

void printDeclaration(Declaration* declaration) {
	if (declaration->attribute != NULL) {
		printAttribute(declaration->attribute);
	}
	
	if (declaration->kind == DeclarationKind_Var) {
		printDeclarationVar(declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Func) {
		printDeclarationFunc(declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Struct) {
		printDeclarationStruct(declaration->declaration, declaration->name);
	} else {
		fprintf(stderr, "Invalid declaration kind %d\n", declaration->kind);
		abort();
	}
}

void printDeclarations(Declaration** declarations, int count) {
	for (int i = 0; i < count; ++i) {
		printDeclaration(declarations[i]);
		printf("\n\n");
	}
}
