#include "Identifier.h"

#include "../../utility/Memory.h"

Identifier* newIdentifier(void) {
	return xcalloc(1, sizeof(Identifier));
}
