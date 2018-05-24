#include "Type.h"

#include "../../utility/Memory.h"

Type* newType(void) {
	return xcalloc(1, sizeof(Type));
}

TypeIdentifier* newTypeIdentifier(void) {
	return xcalloc(1, sizeof(TypeIdentifier));
}

TypePointer* newTypePointer(void) {
	return xcalloc(1, sizeof(TypePointer));
}

TypeFunction* newTypeFunction(void) {
	return xcalloc(1, sizeof(TypeFunction));
}
