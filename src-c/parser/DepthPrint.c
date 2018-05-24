#include "DepthPrint.h"

#include <stdio.h>

int depth = 0;

void printDepth(void) {
	for (int i = 0; i < depth; ++i) { printf(" "); }
}
