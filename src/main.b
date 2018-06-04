func main(argc: int, argv: char**): int {
	if (argc == (int)2 && strcmp(argv[1], (char*)"--version") == (int)0) {
		printVersion(argv[0]);
	};
	
	if (argc < (int)3) { printUsage(argv[0]); };
	if (argv[1][0] != (char)'-') { printUsage(argv[0]); };
	if (argv[1][2] != (char)0) { printUsage(argv[0]); };
	
	var flags = (UInt8)0;
	if (argv[1][1] == (char)'l') {
		flags = (UInt8)1;
	} else if (argv[1][1] == (char)'p') {
		flags = (UInt8)2;
	} else if (argv[1][1] == (char)'r') {
		flags = (UInt8)4;
	} else if (argv[1][1] == (char)'g') {
		flags = (UInt8)8;
	} else { printUsage(argv[0]); };;;;
	bmain(&argv[2], (UInt)argc - 2, flags);
	
	exit(EXIT_SUCCESS);
};

func printVersion(self: char*) {
	printf((char*)"B Compiler (%s) Version 0.0.24%c", self, 10);
	exit(EXIT_SUCCESS);
};

func printUsage(self: char*) {
	printf((char*)"Usage: %s <option> file...%c", self, 10);
	printf((char*)"Options:%c", 10);
	printf((char*)"  --version                Print the version%c", 10);
	printf((char*)"  -l                       Lex and output tokens%c", 10);
	printf((char*)"  -p                       Parse and output ast%c", 10);
	printf((char*)"  -r                       Resolve and output errors%c", 10);
	printf((char*)"  -g                       Codegen and output C%c", 10);
	exit(EXIT_FAILURE);
};

func bmain(files: char**, fileCount: UInt, flags: UInt8) {
	var i = 0;
	while (i < fileCount) {
		_codeLength = readFile(files[i], &_code);
		
		var tempFlags = flags;
		
		_file = (UInt8*)files[i];
		Lex();
		if (flags & (UInt8)1 != (UInt8)0) { printTokens(); };
		flags = flags / (UInt8)2;
		if (flags != (UInt8)0) {
			Parse();
			if (flags & (UInt8)1 != (UInt8)0) { printDeclarations(); };
		};
		
		flags = tempFlags;
		
		i = i + 1;
	};
	
	flags = flags / (UInt8)4;
	if (flags == (UInt8)0) { return; };
	
	Resolve();
	flags = flags / (UInt8)2;
	if (flags == (UInt8)0) { return; };
	
	Codegen();
};
