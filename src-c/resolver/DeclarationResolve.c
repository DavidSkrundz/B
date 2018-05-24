#include "DeclarationResolve.h"

#include <stdio.h>
#include <stdlib.h>

#include "../parser/declaration/DeclarationKind.h"
#include "../parser/declaration/DeclarationState.h"
#include "type/TypeResolve.h"
#include "TypespecResolve.h"
#include "StatementResolve.h"
#include "ExpressionResolve.h"
#include "type/TypeBuiltin.h"
#include "Context.h"
#include "../utility/Memory.h"

extern Context* context;

Type* resolveDeclarationVar(DeclarationVar* declaration, Identifier* name) {
	Type* type = NULL;
	if (declaration->type != NULL) {
		type = resolveTypespec(declaration->type);
	}
	if (declaration->value != NULL) {
		Type* expressionType = resolveExpression(declaration->value, type);
		if (type == NULL) { type = expressionType; }
	}
	addTo(context, name, type);
	return type;
}

Type* resolveDeclarationFuncArg(DeclarationFuncArg* argument) {
	argument->resolvedType = resolveTypespec(argument->type);
	return argument->resolvedType;
}

extern int MAX_FUNC_ARGUMENT_COUNT;
Type** resolveDeclarationFuncArgs(DeclarationFuncArgs* args) {
	Type** argumentTypes = xcalloc(MAX_FUNC_ARGUMENT_COUNT, sizeof(Type*));
	for (int i = 0; i < args->count; ++i) {
		argumentTypes[i] = resolveDeclarationFuncArg(args->args[i]);
	}
	return argumentTypes;
}

Type* resolveDeclarationTypeFunc(DeclarationFunc* declaration, Identifier* name) {
	Type** argumentTypes = resolveDeclarationFuncArgs(declaration->args);
	Type* returnType = TypeVoid;
	if (declaration->returnType != NULL) {
		returnType = resolveTypespec(declaration->returnType);
	}
	Type* type = resolveTypeFunction(returnType, argumentTypes, declaration->args->count, declaration->args->isVariadic);
	if (type == NULL) {
		type = createTypeFunction(returnType, argumentTypes, declaration->args->count, declaration->args->isVariadic);
	}
	addTo(context, name, type);
	return type;
}

void resolveDeclarationStructFields(DeclarationStructFields* fields) {
	for (int i = 0; i < fields->count; ++i) {
		resolveDeclarationDefinition(fields->fields[i]);
	}
}

Type* resolveDeclarationStruct(DeclarationStruct* declaration, Identifier* name) {
	return createTypeIdentifier(name);
}

void resolveDeclarationDefinitionStruct(DeclarationStruct* declaration, Identifier* name) {
	int before = context->count;
	if (declaration->fields != NULL) {
		resolveDeclarationStructFields(declaration->fields);
	}
	context->count = before;
}

void resolveDeclarationType(Declaration* declaration) {
	if (declaration->kind == DeclarationKind_Var) {
	} else if (declaration->kind == DeclarationKind_Func) {
	} else if (declaration->kind == DeclarationKind_Struct) {
		declaration->resolvedType = resolveDeclarationStruct(declaration->declaration, declaration->name);
	} else {
		fprintf(stderr, "Invalid declaration kind %d\n", declaration->kind);
		abort();
	}
}

void resolveDeclarationDefinition(Declaration* declaration) {
	if (declaration->state == DeclarationState_Resolved) { return; }
	else if (declaration->state == DeclarationState_Unresolved) {}
	else if (declaration->state == DeclarationState_Resolving) {
		fprintf(stderr, "Cyclic dependency\n");
		exit(EXIT_FAILURE);
	} else {
		fprintf(stderr, "Invalid declaration state %d\n", declaration->state);
		abort();
	}
	
	declaration->state = DeclarationState_Resolving;
	if (declaration->kind == DeclarationKind_Var) {
		declaration->resolvedType = resolveDeclarationVar(declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Func) {
		declaration->resolvedType = resolveDeclarationTypeFunc(declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Struct) {
		resolveDeclarationDefinitionStruct(declaration->declaration, declaration->name);
	} else {
		fprintf(stderr, "Invalid declaration kind %d\n", declaration->kind);
		abort();
	}
	declaration->state = DeclarationState_Resolved;
}

Type* resolveDeclarationImplementationFunc(DeclarationFunc* declaration, Identifier* name) {
	Type** argumentTypes = resolveDeclarationFuncArgs(declaration->args);
	Type* returnType = TypeVoid;
	if (declaration->returnType != NULL) {
		returnType = resolveTypespec(declaration->returnType);
	}
	if (declaration->block != NULL) {
		int oldContextCount = context->count;
		for (int i = 0; i < declaration->args->count; ++i) {
			DeclarationFuncArg* argument = declaration->args->args[i];
			addTo(context, argument->name, argument->resolvedType);
		}
		resolveStatementBlock(declaration->block, returnType);
		context->count = oldContextCount;
	}
	Type* type = resolveTypeFunction(returnType, argumentTypes, declaration->args->count, declaration->args->isVariadic);
	if (type == NULL) {
		type = createTypeFunction(returnType, argumentTypes, declaration->args->count, declaration->args->isVariadic);
	}
	return type;
}

void resolveDeclarationImplementation(Declaration* declaration) {
	if (declaration->state != DeclarationState_Resolved) {
		fprintf(stderr, "Declaration not resolved before resolving implementation");
		abort();
	}
	if (declaration->kind == DeclarationKind_Var) {
	} else if (declaration->kind == DeclarationKind_Func) {
		declaration->resolvedType = resolveDeclarationImplementationFunc(declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Struct) {
	} else {
		fprintf(stderr, "Invalid declaration kind %d\n", declaration->kind);
		abort();
	}
}
