#include "TypeKind.h"

int TypeKind_Invalid;
int TypeKind_Identifier;
int TypeKind_Pointer;
int TypeKind_Function;

void InitTypeKinds(void) {
	int counter = 0;
	
	TypeKind_Invalid = counter++;
	TypeKind_Identifier = counter++;
	TypeKind_Pointer = counter++;
	TypeKind_Function = counter++;
}
