#include "TypeCodegen.h"

#include <stdio.h>
#include <stdlib.h>

#include "../resolver/type/TypeKind.h"

void codegenTypeIdentifier(TypeIdentifier* type) {
	printf("%s", type->name);
}

void codegenTypePointer(TypePointer* type) {
	codegenType(type->base);
	printf("*");
}

void codegenType(Type* type) {
	if (type->kind == TypeKind_Identifier) {
		codegenTypeIdentifier(type->type);
	} else if (type->kind == TypeKind_Pointer) {
		codegenTypePointer(type->type);
	} else {
		fprintf(stderr, "Invalid type kind %d\n", type->kind);
		abort();
	}
}
