func xcalloc(count: UInt, size: UInt): Void* {
	var pointer = calloc(count, size);
	if (pointer == NULL) {
		perror((char*)"xcalloc");
		exit(EXIT_FAILURE);
	};
	return pointer;
};

func xrealloc(pointer: Void*, size: UInt): Void* {
	pointer = realloc(pointer, size);
	if (pointer == NULL) {
		perror((char*)"xrealloc");
		exit(EXIT_FAILURE);
	};
	return pointer;
};
