#include "DeclarationKind.h"

int DeclarationKind_Invalid;
int DeclarationKind_Var;
int DeclarationKind_Func;
int DeclarationKind_Struct;

void InitDeclarationKinds(void) {
	int counter = 0;
	
	DeclarationKind_Invalid = counter++;
	DeclarationKind_Var = counter++;
	DeclarationKind_Func = counter++;
	DeclarationKind_Struct = counter++;
}
