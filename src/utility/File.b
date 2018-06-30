func readFile(fileName: char*, buffer: UInt8**): UInt {
	var file: FILE*;
	
	file = fopen(fileName, (char*)"r");
	if (file == NULL) { FileError(fileName, "could not open "); };
	fseek(file, 0, SEEK_END);
	var length = ftell(file);
	fseek(file, 0, SEEK_SET);
	
	*buffer = (UInt8*)xcalloc(length + 1, sizeof(char));
	
	if (length == 0 || fread(*buffer, length, 1, file) == 1) {
	} else { FileError(fileName, "could not read "); };
	
	fclose(file);
	
	(*buffer)[length] = (UInt8)0;
	return length;
};

func FileError(file: char*, message: UInt8*) {
	fprintf(stderr, (char*)"%s", (char*)message);
	perror(file);
	exit(EXIT_FAILURE);
};
