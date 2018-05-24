#pragma once

#include <stdbool.h>

#include "../identifier/Identifier.h"
#include "../attribute/Attribute.h"
#include "../typespec/Typespec.h"
#include "../statement/Statement.h"
#include "../expression/Expression.h"
#include "../../resolver/type/Type.h"

struct Declaration {
	int kind;
	int state;
	Attribute* attribute;
	Identifier* name;
	void* declaration;
	Type* resolvedType;
};

typedef struct {
	Typespec* type;
	Expression* value;
} DeclarationVar;

typedef struct {
	Identifier* name;
	Typespec* type;
	Type* resolvedType;
} DeclarationFuncArg;

typedef struct {
	DeclarationFuncArg** args;
	int count;
	bool isVariadic;
} DeclarationFuncArgs;

typedef struct {
	DeclarationFuncArgs* args;
	Typespec* returnType;
	StatementBlock* block;
} DeclarationFunc;

typedef struct {
	Declaration** fields;
	int count;
} DeclarationStructFields;

typedef struct {
	DeclarationStructFields* fields;
} DeclarationStruct;

Declaration* newDeclaration(void);
DeclarationVar* newDeclarationVar(void);
DeclarationFuncArg* newDeclarationFuncArg(void);
DeclarationFuncArgs* newDeclarationFuncArgs(void);
DeclarationFunc* newDeclarationFunc(void);
DeclarationStructFields* newDeclarationStructFields(void);
DeclarationStruct* newDeclarationStruct(void);
