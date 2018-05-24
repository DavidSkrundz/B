#include "Typespec.h"

#include "../../utility/Memory.h"

Typespec* newTypespec(void) {
	return xcalloc(1, sizeof(Typespec));
}

TypespecPointer* newTypespecPointer(void) {
	return xcalloc(1, sizeof(TypespecPointer));
}

TypespecIdentifier* newTypespecIdentifier(void) {
	return xcalloc(1, sizeof(TypespecIdentifier));
}
