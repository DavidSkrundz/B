@foreign(c) struct int;
@foreign(c) struct char;
@foreign(c, stdio) func printf(format: char*, ...);

func main(argc: int, argv: char**): int {
	var a = 1;
	if (true) {
		var a = 2;
		printf((char*)"%zu\n", a);
	};
	printf((char*)"%zu\n", a);
};
