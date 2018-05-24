#include "IdentifierCodegen.h"

#include <stdio.h>

void codegenIdentifier(Identifier* identifier) {
	printf("%.*s", identifier->length, identifier->name);
}
