#include "Declaration.h"

#include "../../utility/Memory.h"

Declaration* newDeclaration(void) {
	return xcalloc(1, sizeof(Declaration));
}

DeclarationVar* newDeclarationVar(void) {
	return xcalloc(1, sizeof(DeclarationVar));
}

DeclarationFuncArg* newDeclarationFuncArg(void) {
	return xcalloc(1, sizeof(DeclarationFuncArg));
}

DeclarationFuncArgs* newDeclarationFuncArgs(void) {
	return xcalloc(1, sizeof(DeclarationFuncArgs));
}

DeclarationFunc* newDeclarationFunc(void) {
	return xcalloc(1, sizeof(DeclarationFunc));
}

DeclarationStructFields* newDeclarationStructFields(void) {
	return xcalloc(1, sizeof(DeclarationStructFields));
}

DeclarationStruct* newDeclarationStruct(void) {
	return xcalloc(1, sizeof(DeclarationStruct));
}
