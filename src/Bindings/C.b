@foreign(c) struct int;
@foreign(c) struct char;

@foreign(c, string) func strchr(string: char*, character: UInt8): char*;
@foreign(c, string) func strcmp(str1: char*, str2: char*): int;
@foreign(c, string) func strncmp(str1: char*, str2: char*, length: UInt): int;
@foreign(c, string) func strlen(str: char*): UInt;
@foreign(c, string) func strndup(str: char*, length: UInt): char*;

@foreign(c, ctype) func isspace(character: UInt8): Bool;
@foreign(c, ctype) func isprint(character: UInt8): Bool;
@foreign(c, ctype) func isdigit(character: UInt8): Bool;
@foreign(c, ctype) func isalnum(character: UInt8): Bool;
