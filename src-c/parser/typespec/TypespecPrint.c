#include "TypespecPrint.h"

#include <stdio.h>
#include <stdlib.h>

#include "../identifier/IdentifierPrint.h"
#include "TypespecKind.h"

void printTypespec(Typespec* typespec) {
	printf("(type ");
	if (typespec->kind == TypespecKind_Pointer) {
		printTypespecPointer(typespec->spec);
	} else if (typespec->kind == TypespecKind_Identifier) {
		printTypespecIdentifier(typespec->spec);
	} else {
		fprintf(stderr, "Invalid typespec kind %d\n", typespec->kind);
		abort();
	}
	printf(")");
}

void printTypespecPointer(TypespecPointer* typespec) {
	printf("(pointer ");
	if (typespec->base->kind == TypespecKind_Pointer) {
		printTypespecPointer(typespec->base->spec);
	} else if (typespec->base->kind == TypespecKind_Identifier) {
		printTypespecIdentifier(typespec->base->spec);
	} else {
		fprintf(stderr, "Invalid typespec kind %d\n", typespec->base->kind);
		abort();
	}
	printf(")");
}

void printTypespecIdentifier(TypespecIdentifier* typespec) {
	printIdentifier(typespec->name);
}
