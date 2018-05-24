#include "AttributePrint.h"

#include <stdio.h>

void printAttribute(Attribute* attribute) {
	printf("@%.*s\n", attribute->name->length, attribute->name->name);
}
