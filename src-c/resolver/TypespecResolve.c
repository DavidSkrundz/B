#include "TypespecResolve.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../parser/typespec/TypespecKind.h"
#include "type/TypeResolve.h"
#include "../parser/Parser.h"
#include "DeclarationResolve.h"

Type* resolveTypespecPointer(TypespecPointer* typespec) {
	Type* base = resolveTypespec(typespec->base);
	Type* type = resolveTypePointer(base);
	if (type != NULL) { return type; }
	return createTypePointer(base);
}

Type* resolveTypespecIdentifier(TypespecIdentifier* typespec) {
	Type* type = resolveTypeIdentifier(typespec->name);
	if (type == NULL) {
		for (int i = 0; i < declarationCount; ++i) {
			if (declarations[i]->name->length != typespec->name->length) { continue; }
			if (strncmp(declarations[i]->name->name, typespec->name->name, typespec->name->length) != 0) { continue; }
			resolveDeclarationType(declarations[i]);
			type = resolveTypeIdentifier(typespec->name);
		}
	}
	if (type == NULL) {
		fprintf(stderr, "Invalid type '%.*s'\n", typespec->name->length, typespec->name->name);
		exit(EXIT_FAILURE);
	}
	return type;
}

Type* resolveTypespec(Typespec* typespec) {
	if (typespec->kind == TypespecKind_Pointer) {
		return resolveTypespecPointer(typespec->spec);
	} else if (typespec->kind == TypespecKind_Identifier) {
		return resolveTypespecIdentifier(typespec->spec);
	} else {
		fprintf(stderr, "Invalid typespec kind %d\n", typespec->kind);
		abort();
	}
}
