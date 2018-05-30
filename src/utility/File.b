func readFile(fileName: char*, buffer: UInt8**): UInt {
	var file: FILE*;
	
	file = fopen(fileName, (char*)"r");
	if (file == NULL) {
		fprintf(stderr, (char*)"could not open ");
		perror(fileName);
		exit(EXIT_FAILURE);
	};
	fseek(file, 0, SEEK_END);
	var length = ftell(file);
	fseek(file, 0, SEEK_SET);
	
	*buffer = (UInt8*)xcalloc(length + 1, sizeof(char));
	
	if (fread(*buffer, length, 1, file) == 1) {
	} else {
		fclose(file);
		fprintf(stderr, (char*)"could not open ");
		perror(fileName);
		exit(EXIT_FAILURE);
	};
	
	fclose(file);
	
	(*buffer)[length] = (UInt8)0;
	return length;
};
