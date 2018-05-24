#include "Memory.h"

#include <stdlib.h>
#include <stdio.h>

void* xcalloc(int count, int size) {
	void* pointer = calloc(count, size);
	if (pointer == NULL) {
		perror("xcalloc");
		exit(EXIT_FAILURE);
	}
	return pointer;
}
