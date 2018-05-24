#include "TypespecKind.h"

int TypespecKind_Invalid;
int TypespecKind_Pointer;
int TypespecKind_Identifier;

void InitTypespecKinds(void) {
	int counter = 0;
	
	TypespecKind_Invalid = counter++;
	TypespecKind_Pointer = counter++;
	TypespecKind_Identifier = counter++;
}
