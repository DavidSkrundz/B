@foreign(c) struct ExitStatus;
@foreign(c, stdlib) var EXIT_FAILURE: ExitStatus;
@foreign(c, stdlib) var EXIT_SUCCESS: ExitStatus;

@foreign(c, stdlib) func exit(status: ExitStatus);

@foreign(c, stdlib) func abort();

func Abort() {
	abort();
};
