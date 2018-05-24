#include "DeclarationCodegen.h"

#include <stdio.h>
#include <stdlib.h>

#include "../parser/Parser.h"
#include "../parser/declaration/DeclarationKind.h"
#include "../resolver/type/TypeKind.h"
#include "IdentifierCodegen.h"
#include "TypeCodegen.h"
#include "StatementCodegen.h"
#include "ExpressionCodegen.h"

void codegenDeclarationStructDeclaration(Declaration* declaration, DeclarationStruct* decl) {
	printf("typedef struct ");
	codegenIdentifier(declaration->name);
	printf(" ");
	codegenIdentifier(declaration->name);
	printf(";\n");
}

void codegenDeclarationDeclaration(Declaration* declaration) {
	if (declaration->attribute != NULL) { return; }
	
	if (declaration->kind == DeclarationKind_Var) {
	} else if (declaration->kind == DeclarationKind_Func) {
	} else if (declaration->kind == DeclarationKind_Struct) {
		codegenDeclarationStructDeclaration(declaration, declaration->declaration);
	} else {
		fprintf(stderr, "Invalid declaration kind %d\n", declaration->kind);
		abort();
	}
}

void CodegenDeclarationDeclarations(void) {
	for (int i = 0; i < declarationCount; ++i) {
		codegenDeclarationDeclaration(declarations[i]);
	}
	printf("\n");
}



void codegenDeclarationVarDefinition(Declaration* declaration, DeclarationVar* decl) {
	codegenType(declaration->resolvedType);
	printf(" ");
	codegenIdentifier(declaration->name);
	printf(" = ");
	if (decl->value == NULL) {
		codegenNullExpression(declaration->resolvedType);
	} else {
		codegenExpression(decl->value);
	}
	printf(";\n");
}

void codegenDeclarationFuncArg(DeclarationFuncArg* argument) {
	codegenType(argument->resolvedType);
	printf(" ");
	codegenIdentifier(argument->name);
}

void codegenDeclarationFuncArgs(DeclarationFuncArgs* args) {
	printf("(");
	if (args->count == 0) {
		printf("void");
	}
	for (int i = 0; i < args->count; ++i) {
		codegenDeclarationFuncArg(args->args[i]);
		if ((i + 1) < args->count) { printf(", "); }
	}
	printf(")");
}

void codegenDeclarationFuncDefinition(Declaration* declaration, DeclarationFunc* decl) {
	if (declaration->resolvedType->kind != TypeKind_Function) {
		fprintf(stderr, "Function declaration has non function type\n");
		abort();
	}
	TypeFunction* funcType = declaration->resolvedType->type;
	codegenType(funcType->returnType);
	printf(" ");
	codegenIdentifier(declaration->name);
	codegenDeclarationFuncArgs(decl->args);
	printf(";\n");
}

void codegenDeclarationStructFieldDefinition(Declaration* field) {
	if (field->kind != DeclarationKind_Var) {
		fprintf(stderr, "Bad declaration kind (%d) in struct fields\n", field->kind);
		abort();
	}
	printf("\t");
	codegenType(field->resolvedType);
	printf(" ");
	codegenIdentifier(field->name);
	printf(";\n");
}

void codegenDeclarationStructFieldsDefinition(DeclarationStructFields* fields) {
	for (int i = 0; i < fields->count; ++i) {
		codegenDeclarationStructFieldDefinition(fields->fields[i]);
	}
}

void codegenDeclarationStructDefinition(Declaration* declaration, DeclarationStruct* decl) {
	printf("struct ");
	codegenIdentifier(declaration->name);
	printf(" {\n");
	codegenDeclarationStructFieldsDefinition(decl->fields);
	printf("};\n");
}

void codegenDeclarationDefinition(Declaration* declaration) {
	if (declaration->attribute != NULL) { return; }
	
	if (declaration->kind == DeclarationKind_Var) {
		codegenDeclarationVarDefinition(declaration, declaration->declaration);
	} else if (declaration->kind == DeclarationKind_Func) {
		codegenDeclarationFuncDefinition(declaration, declaration->declaration);
	} else if (declaration->kind == DeclarationKind_Struct) {
		codegenDeclarationStructDefinition(declaration, declaration->declaration);
	} else {
		fprintf(stderr, "Invalid declaration kind %d\n", declaration->kind);
		abort();
	}
}

void CodegenDeclarationDefinitions(void) {
	for (int i = 0; i < declarationCount; ++i) {
		codegenDeclarationDefinition(declarations[i]);
	}
	printf("\n");
}



void codegenDeclarationFuncImplementation(Declaration* declaration, DeclarationFunc* decl) {
	if (declaration->resolvedType->kind != TypeKind_Function) {
		fprintf(stderr, "Function declaration has non function type\n");
		abort();
	}
	TypeFunction* funcType = declaration->resolvedType->type;
	codegenType(funcType->returnType);
	printf(" ");
	codegenIdentifier(declaration->name);
	codegenDeclarationFuncArgs(decl->args);
	printf(" ");
	codegenStatementBlock(decl->block);
	printf("\n\n");
}

void codegenDeclarationImplementation(Declaration* declaration) {
	if (declaration->attribute != NULL) { return; }
	
	if (declaration->kind == DeclarationKind_Var) {
	} else if (declaration->kind == DeclarationKind_Func) {
		codegenDeclarationFuncImplementation(declaration, declaration->declaration);
	} else if (declaration->kind == DeclarationKind_Struct) {
	} else {
		fprintf(stderr, "Invalid declaration kind %d\n", declaration->kind);
		abort();
	}
}

void CodegenDeclarationImplementations(void) {
	for (int i = 0; i < declarationCount; ++i) {
		codegenDeclarationImplementation(declarations[i]);
	}
}
