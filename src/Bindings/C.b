@foreign(c) struct int;
@foreign(c) struct char;

@foreign(c) struct ExitStatus;
@foreign(c, stdlib) var EXIT_FAILURE: ExitStatus;
@foreign(c, stdlib) var EXIT_SUCCESS: ExitStatus;
@foreign(c, stdlib) func exit(status: ExitStatus);
@foreign(c, stdlib) func abort();

@foreign(c, stdio) struct FILE;
@foreign(c, stdio) func fopen(file: char*, mode: char*): FILE*;
@foreign(c, stdio) func fclose(file: FILE*);
@foreign(c, stdio) func ftell(file: FILE*): UInt;
@foreign(c, stdio) func fread(buffer: UInt8*, size: UInt, count: UInt, file: FILE*): UInt;

@foreign(c, stdio) var stderr: FILE*;
@foreign(c, stdio) var stdout: FILE*;
@foreign(c, stdio) func printf(format: char*, ...);
@foreign(c, stdio) func fprintf(stream: FILE*, format: char*, ...);
@foreign(c, stdio) func perror(message: char*);

@foreign(c, stdio) struct SeekPosition;
@foreign(c, stdio) var SEEK_SET: SeekPosition;
@foreign(c, stdio) var SEEK_END: SeekPosition;
@foreign(c, stdio) func fseek(file: FILE*, distance: UInt, from: SeekPosition);

@foreign(c, string) func strchr(string: char*, character: UInt8): char*;
@foreign(c, string) func strcmp(str1: char*, str2: char*): int;
@foreign(c, string) func strncmp(str1: char*, str2: char*, length: UInt): int;
@foreign(c, string) func strlen(str: char*): UInt;
@foreign(c, string) func strndup(str: char*, length: UInt): char*;

@foreign(c, stdlib) func calloc(count: UInt, size: UInt): Void*;
@foreign(c, stdlib) func realloc(pointer: Void*, size: UInt): Void*;

@foreign(c, ctype) func isspace(character: UInt8): Bool;
@foreign(c, ctype) func isprint(character: UInt8): Bool;
@foreign(c, ctype) func isdigit(character: UInt8): Bool;
@foreign(c, ctype) func isalnum(character: UInt8): Bool;
