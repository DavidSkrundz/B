#include "File.h"

#include <stdio.h>
#include <stdlib.h>

#include "Memory.h"

static int NewlinesBetweenFiles = 3;

int readFiles(char** fileNames, int fileCount, char** buffer) {
	FILE** files = xcalloc(fileCount, sizeof(FILE*));
	int* lengths = xcalloc(fileCount, sizeof(int));
	int totalLength = 0;
	
	for (int i = 0; i < fileCount; ++i) {
		files[i] = fopen(fileNames[i], "r");
		if (files[i] == NULL) {
			fprintf(stderr, "could not open ");
			perror(fileNames[i]);
			exit(EXIT_FAILURE);
		}
		fseek(files[i], 0, SEEK_END);
		lengths[i] = (int)ftell(files[i]);
		totalLength += lengths[i] + NewlinesBetweenFiles;
		fseek(files[i], 0, SEEK_SET);
	}
	
	int currentLength = 0;
	*buffer = xcalloc(totalLength + 1, sizeof(char));
	
	for (int i = 0; i < fileCount; ++i) {
		if (fread(&(*buffer)[currentLength], lengths[i], 1, files[i]) != 1) {
			fclose(files[i]);
			fprintf(stderr, "could not open ");
			perror(fileNames[i]);
			exit(EXIT_FAILURE);
		}
		currentLength += lengths[i];
		for (int i = 0; i < NewlinesBetweenFiles; ++i) {
			(*buffer)[currentLength++] = '\n';
		}
	}
	
	for (int i = 0; i < fileCount; ++i) {
		fclose(files[i]);
	}
	
	(*buffer)[totalLength] = '\0';
	return totalLength;
}
