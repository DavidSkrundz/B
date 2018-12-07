@foreign(c, stdlib) func malloc(size: UInt): Void*;
@foreign(c, stdlib) func calloc(count: UInt, size: UInt): Void*;
@foreign(c, stdlib) func valloc(size: UInt): Void*;
@foreign(c, stdlib) func realloc(pointer: Void*, size: UInt): Void*;
@foreign(c, stdlib) func free(pointer: Void*);

func Malloc(size: UInt): Void* {
	var pointer = malloc(size);
	if (pointer == NULL) {
		perror((char*)"Malloc");
		exit(EXIT_FAILURE);
	};
	return pointer;
};

func Calloc(count: UInt, size: UInt): Void* {
	var pointer = calloc(count, size);
	if (pointer == NULL) {
		perror((char*)"Calloc");
		exit(EXIT_FAILURE);
	};
	return pointer;
};

func Valloc(size: UInt): Void* {
	var pointer = valloc(size);
	if (pointer == NULL) {
		perror((char*)"Valloc");
		exit(EXIT_FAILURE);
	};
	return pointer;
};

func Realloc(pointer: Void*, size: UInt): Void* {
	pointer = realloc(pointer, size);
	if (pointer == NULL) {
		perror((char*)"Realloc");
		exit(EXIT_FAILURE);
	};
	return pointer;
};

func Free(pointer: Void*) {
	free(pointer);
};
