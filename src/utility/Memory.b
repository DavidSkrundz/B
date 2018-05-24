func xcalloc(count: UInt, size: UInt): Void* {
	var pointer = calloc(count, size);
	if (pointer == NULL) {
		perror((char*)"xcalloc");
		exit(EXIT_FAILURE);
	};
	return pointer;
};
