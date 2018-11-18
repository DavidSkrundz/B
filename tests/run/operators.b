@foreign(c) struct int;
@foreign(c) struct char;
@foreign(c, stdio) func printf(format: char*, ...);

func main(argc: int, argv: char**): int {
	printf((char*)"%d\n", 5 + 3);
	printf((char*)"%d\n", 5 - 3);
	printf((char*)"%d\n", 5 * 3);
	printf((char*)"%d\n", 5 / 3);
	
	printf((char*)"%d\n", 10 | 3);
	printf((char*)"%d\n", 10 & 3);
	printf((char*)"%d\n", 10 ^ 3);
	
	printf((char*)"%d\n", 5 == 3);
	printf((char*)"%d\n", 5 != 3);
	printf((char*)"%d\n", 5  < 3);
	printf((char*)"%d\n", 5  > 3);
	printf((char*)"%d\n", 5 <= 3);
	printf((char*)"%d\n", 5 >= 3);
	
	printf((char*)"%d\n", !true);
	printf((char*)"%d\n", !false);
	printf((char*)"%d\n", true || false);
	printf((char*)"%d\n", true && false);
	
	printf((char*)"%d\n",  1 << 4);
	printf((char*)"%d\n", 18 >> 2);
	
	printf((char*)"%d\n", false ? 1 : 2);
};
