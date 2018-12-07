@foreign(c, stdio) func perror(message: char*);
@foreign(c, stdio) func printf(format: char*, ...);

func PrintString(string: UInt8*) {
	printf((char*)"%s", (char*)string);
};

func PrintUInt(uint: UInt) {
	printf((char*)"%zu", uint);
};

func PrintError(message: UInt8*) {
	fprintf(stderr, (char*)"%s", (char*)message);
};

func PError(message: UInt8*) {
	perror((char*)message);
};
