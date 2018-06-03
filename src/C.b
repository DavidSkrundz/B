@foreign struct int;
@foreign struct char;

@foreign struct ExitStatus;
@foreign var EXIT_FAILURE: ExitStatus;
@foreign var EXIT_SUCCESS: ExitStatus;
@foreign func exit(status: ExitStatus);
@foreign func abort();

@foreign struct FILE;
@foreign func fopen(file: char*, mode: char*): FILE*;
@foreign func fclose(file: FILE*);
@foreign func ftell(file: FILE*): UInt;
@foreign func fread(buffer: UInt8*, size: UInt, count: UInt, file: FILE*): UInt;

@foreign var stderr: FILE*;
@foreign var stdout: FILE*;
@foreign func printf(format: char*, ...);
@foreign func fprintf(stream: FILE*, format: char*, ...);
@foreign func perror(message: char*);

@foreign struct SeekPosition;
@foreign var SEEK_SET: SeekPosition;
@foreign var SEEK_END: SeekPosition;
@foreign func fseek(file: FILE*, distance: UInt, from: SeekPosition);

@foreign func strchr(string: char*, character: UInt8): char*;
@foreign func strcmp(str1: char*, str2: char*): int;
@foreign func strncmp(str1: char*, str2: char*, length: UInt): int;
@foreign func strlen(str: char*): UInt;
@foreign func strndup(str: char*, length: UInt): char*;

@foreign func calloc(count: UInt, size: UInt): Void*;
@foreign func realloc(pointer: Void*, size: UInt): Void*;

@foreign func isspace(character: UInt8): Bool;
@foreign func isprint(character: UInt8): Bool;
@foreign func isdigit(character: UInt8): Bool;
@foreign func isalnum(character: UInt8): Bool;
