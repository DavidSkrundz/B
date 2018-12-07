@foreign(c, stdio) struct FILE;
@foreign(c, stdio) var stderr: FILE*;
@foreign(c, stdio) var stdout: FILE*;

@foreign(c, stdio) struct SeekPosition;
@foreign(c, stdio) var SEEK_SET: SeekPosition;
@foreign(c, stdio) var SEEK_CUR: SeekPosition;
@foreign(c, stdio) var SEEK_END: SeekPosition;

@foreign(c, stdio) func fopen(file: char*, mode: char*): FILE*;
@foreign(c, stdio) func fclose(file: FILE*);

@foreign(c, stdio) func fread(buffer: UInt8*, size: UInt, count: UInt, file: FILE*): UInt;

@foreign(c, stdio) func ftell(file: FILE*): UInt;
@foreign(c, stdio) func fseek(file: FILE*, distance: UInt, from: SeekPosition);

@foreign(c, stdio) func fprintf(stream: FILE*, format: char*, ...);

struct File {
	var name: UInt8*;
	var file: FILE*;
	
	func close() {
		fclose(self->file);
		self->file = NULL;
	};
	
	func seekToStart() {
		fseek(self->file, 0, SEEK_SET);
	};
	
	func seekToEnd() {
		fseek(self->file, 0, SEEK_END);
	};
	
	func getLength(): UInt {
		self->seekToEnd();
		return ftell(self->file);
	};
	
	func readAll(buffer: UInt8**): UInt {
		var length = self->getLength();
		self->seekToStart();
		*buffer = (UInt8*)Calloc(length + 1, sizeof(UInt8));
		
		if (length == 0 || fread(*buffer, length, 1, self->file) == 1) {
		} else {
			PrintError("could not read ");
			PError(self->name);
		};
		
		(*buffer)[length] = (UInt8)0;
		return length;
	};
};

func OpenFile(name: UInt8*, mode: UInt8*): File* {
	var file = (File*)Malloc(sizeof(File));
	file->name = name;
	file->file = fopen((char*)name, (char*)mode);
	if (file->file == NULL) {
		PrintError("could not open ");
		PError(name);
	};
	return file;
};
