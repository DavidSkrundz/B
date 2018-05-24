#include "TypeResolve.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../Resolver.h"
#include "TypeKind.h"

bool isPointer(Type* type) {
	return type->kind == TypeKind_Pointer;
}

Type* getPointerBase(Type* type) {
	if (type->kind == TypeKind_Identifier) {
		fprintf(stderr, "Not a pointer\n");
		abort();
	} else if (type->kind == TypeKind_Pointer) {
		TypePointer* pointer = type->type;
		return pointer->base;
	} else if (type->kind == TypeKind_Function) {
		fprintf(stderr, "Not a pointer\n");
		abort();
	} else {
		fprintf(stderr, "Invalid type kind %d\n", type->kind);
		exit(EXIT_FAILURE);
	}
}

extern int MAX_TYPE_COUNT;
void registerType(Type* type) {
	if (typeCount >= MAX_TYPE_COUNT) {
		fprintf(stderr, "Too many types are defined\n");
		exit(EXIT_FAILURE);
	}
	types[typeCount++] = type;
}

Type* resolveTypeIdentifier(Identifier* name) {
	for (int i = 0; i < typeCount; ++i) {
		Type* type = types[i];
		if (type->kind == TypeKind_Identifier) {
			TypeIdentifier* identifier = type->type;
			if (name->length != strlen(identifier->name)) { continue; }
			if (strncmp(identifier->name, name->name, name->length) == 0) {
				return type;
			}
		} else { continue; }
	}
	return NULL;
}

Type* resolveTypePointer(Type* base) {
	for (int i = 0; i < typeCount; ++i) {
		Type* type = types[i];
		if (type->kind != TypeKind_Pointer) { continue; }
		TypePointer* pointer = type->type;
		if (pointer->base == base) { return type; }
	}
	return NULL;
}

Type* resolveTypeFunction(Type* returnType, Type** argumentTypes, int argumentCount, bool isVariadic) {
	for (int i = 0; i < typeCount; ++i) {
		Type* type = types[i];
		if (type->kind != TypeKind_Function) { continue; }
		TypeFunction* funcType = type->type;
		if (funcType->isVariadic != isVariadic) { continue; }
		if (funcType->returnType != returnType) { continue; }
		if (funcType->count != argumentCount) { continue; }
		bool isMatch = true;
		for (int j = 0; j < argumentCount; ++j) {
			if (funcType->argumentTypes[j] != argumentTypes[j]) {
				isMatch = false;
				break;
			}
		}
		if (isMatch) { return type; }
	}
	return NULL;
}

Type* createTypeIdentifierString(char* name) {
	Identifier* identifier = newIdentifier();
	identifier->name = name;
	identifier->length = (int)strlen(name);
	return createTypeIdentifier(identifier);
}

Type* createTypeIdentifier(Identifier* name) {
	if (resolveTypeIdentifier(name) != NULL) {
		fprintf(stderr, "Type already exists: %.*s\n", name->length, name->name);
		exit(EXIT_FAILURE);
	}
	TypeIdentifier* typeIdentifier = newTypeIdentifier();
	typeIdentifier->name = strndup(name->name, name->length);
	Type* type = newType();
	type->kind = TypeKind_Identifier;
	type->type = typeIdentifier;
	registerType(type);
	return type;
}

Type* createTypePointer(Type* base) {
	if (resolveTypePointer(base) != NULL) {
		fprintf(stderr, "Pointer type already created\n");
		abort();
	}
	TypePointer* typePointer = newTypePointer();
	typePointer->base = base;
	Type* type = newType();
	type->kind = TypeKind_Pointer;
	type->type = typePointer;
	registerType(type);
	return type;
}

Type* createTypeFunction(Type* returnType, Type** argumentTypes, int argumentCount, bool isVariadic) {
	if (resolveTypeFunction(returnType, argumentTypes, argumentCount, isVariadic) != NULL) {
		fprintf(stderr, "Function type already created\n");
		abort();
	}
	TypeFunction* funcType = newTypeFunction();
	funcType->returnType = returnType;
	funcType->argumentTypes = argumentTypes;
	funcType->count = argumentCount;
	funcType->isVariadic = isVariadic;
	Type* type = newType();
	type->kind = TypeKind_Function;
	type->type = funcType;
	registerType(type);
	return type;
}
