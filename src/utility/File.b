func readFile(fileName: char*, buffer: UInt8**): UInt {
	var file: FILE*;
	var lengths: UInt* = (UInt*)xcalloc(1, sizeof(Int));
	var totalLength = 0;
	
	var index = 0;
	file = fopen(fileName, (char*)"r");
	if (file == NULL) {
		fprintf(stderr, (char*)"could not open ");
		perror(fileName);
		exit(EXIT_FAILURE);
	};
	fseek(file, 0, SEEK_END);
	lengths[index] = ftell(file);
	totalLength = totalLength + lengths[index];
	fseek(file, 0, SEEK_SET);
	
	var currentLength = 0;
	*buffer = (UInt8*)xcalloc(totalLength + 1, sizeof(char));
	
	index = 0;
	if (fread(&(*buffer)[currentLength], lengths[index], 1, file) == 1) {
	} else {
		fclose(file);
		fprintf(stderr, (char*)"could not open ");
		perror(fileName);
		exit(EXIT_FAILURE);
	};
	currentLength = currentLength + lengths[index];
	
	index = 0;
	fclose(file);
	
	(*buffer)[totalLength] = (UInt8)0;
	return totalLength;
};
