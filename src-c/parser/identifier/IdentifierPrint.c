#include "IdentifierPrint.h"

#include <stdio.h>

void printIdentifier(Identifier* identifier) {
	printf("(identifier %.*s)", identifier->length, identifier->name);
}
