var NewlinesBetweenFiles = 3;

func readFile(fileNames: char**, fileCount: UInt, buffer: UInt8**): UInt {
	var files: FILE** = (FILE**)xcalloc(fileCount, sizeof(FILE*));
	var lengths: UInt* = (UInt*)xcalloc(fileCount, sizeof(Int));
	var totalLength = 0;
	
	var index = 0;
	while (index < fileCount) {
		files[index] = fopen(fileNames[index], (char*)"r");
		if (files[index] == NULL) {
			fprintf(stderr, (char*)"could not open ");
			perror(fileNames[index]);
			exit(EXIT_FAILURE);
		};
		fseek(files[index], 0, SEEK_END);
		lengths[index] = ftell(files[index]);
		totalLength = totalLength + lengths[index] + NewlinesBetweenFiles;
		fseek(files[index], 0, SEEK_SET);
		index = index + 1;
	};
	
	var currentLength = 0;
	*buffer = (UInt8*)xcalloc(totalLength + 1, sizeof(char));
	
	index = 0;
	while (index < fileCount) {
		if (fread(&(*buffer)[currentLength], lengths[index], 1, files[index]) == 1) {
		} else {
			fclose(files[index]);
			fprintf(stderr, (char*)"could not open ");
			perror(fileNames[index]);
			exit(EXIT_FAILURE);
		};
		currentLength = currentLength + lengths[index];
		var lines = 0;
		while (lines < NewlinesBetweenFiles) {
			(*buffer)[currentLength] = (UInt8)10;
			currentLength = currentLength + 1;
			lines = lines + 1;
		};
		index = index + 1;
	};
	
	index = 0;
	while (index < fileCount) {
		fclose(files[index]);
		index = index + 1;
	};
	
	(*buffer)[totalLength] = (UInt8)0;
	return totalLength;
};
