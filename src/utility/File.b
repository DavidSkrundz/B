func readFile(fileNames: char**, buffer: UInt8**): UInt {
	var files: FILE** = (FILE**)xcalloc(1, sizeof(FILE*));
	var lengths: UInt* = (UInt*)xcalloc(1, sizeof(Int));
	var totalLength = 0;
	
	var index = 0;
	files[index] = fopen(fileNames[index], (char*)"r");
	if (files[index] == NULL) {
		fprintf(stderr, (char*)"could not open ");
		perror(fileNames[index]);
		exit(EXIT_FAILURE);
	};
	fseek(files[index], 0, SEEK_END);
	lengths[index] = ftell(files[index]);
	totalLength = totalLength + lengths[index];
	fseek(files[index], 0, SEEK_SET);
	
	var currentLength = 0;
	*buffer = (UInt8*)xcalloc(totalLength + 1, sizeof(char));
	
	index = 0;
	if (fread(&(*buffer)[currentLength], lengths[index], 1, files[index]) == 1) {
	} else {
		fclose(files[index]);
		fprintf(stderr, (char*)"could not open ");
		perror(fileNames[index]);
		exit(EXIT_FAILURE);
	};
	currentLength = currentLength + lengths[index];
	
	index = 0;
	fclose(files[index]);
	
	(*buffer)[totalLength] = (UInt8)0;
	return totalLength;
};
