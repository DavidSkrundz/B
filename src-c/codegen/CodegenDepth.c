#include "CodegenDepth.h"

#include <stdio.h>

int genDepth = 0;

void codegenDepth(void) {
	for (int i = 0; i < genDepth; ++i) { printf("\t"); }
}
