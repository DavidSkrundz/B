#include "Attribute.h"

#include "../../utility/Memory.h"

Attribute* newAttribute(void) {
	return xcalloc(1, sizeof(Attribute));
}
