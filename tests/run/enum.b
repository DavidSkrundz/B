@foreign(c) struct int;
@foreign(c) struct char;
@foreign(c, stdio) func printf(format: char*, ...);

enum ExitStatus {
	case Success;
	case Failure;
};

func main(argc: int, argv: char**): int {
	var a = ExitStatus.Success;
	var b: ExitStatus = .Failure;
	printf((char*)"%d\n", a);
	printf((char*)"%d\n", b);
};
