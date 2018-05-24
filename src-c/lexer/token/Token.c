#include "Token.h"

#include <stdio.h>
#include <stdlib.h>

Token* newToken(void) {
	return calloc(1, sizeof(Token));
}
