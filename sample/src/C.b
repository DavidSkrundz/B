@foreign(c) struct int;
@foreign(c) struct char;

@foreign(c, stdlib) func abort();

@foreign(c, stdio) func printf(format: char*, ...);

func Print(string: UInt8*) {
	printf((char*)"%s\n", (char*)string);
};
