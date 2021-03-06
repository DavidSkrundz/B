func main(argc: int, argv: char**): int {
	if (argc == (int)2 && strcmp(argv[1], (char*)"--version") == (int)0) {
		printVersion(argv[0]);
	};
	
	if (argc < (int)3) { printUsage(argv[0]); };
	if (argv[1][0] != (char)'-') { printUsage(argv[0]); };
	if (argv[1][2] != (char)0) { printUsage(argv[0]); };
	
	var flags = (UInt8)0;
	if (argv[1][1] == (char)'l') {
		flags = (UInt8)(1 << 0);
	} else if (argv[1][1] == (char)'p') {
		flags = (UInt8)(1 << 1);
	} else if (argv[1][1] == (char)'r') {
		flags = (UInt8)(1 << 2);
	} else if (argv[1][1] == (char)'g') {
		flags = (UInt8)(1 << 3);
	} else { printUsage(argv[0]); };;;;
	bmain((UInt8**)&argv[2], (UInt)argc - 2, flags);
	
	exit(EXIT_SUCCESS);
};

func printVersion(self: char*) {
	printf((char*)"B Compiler (%s) Version 0.0.43\n", self);
	exit(EXIT_SUCCESS);
};

func printUsage(self: char*) {
	printf((char*)"Usage: %s <option> file...\n", self);
	PrintString("Options:\n");
	PrintString("  --version                Print the version\n");
	PrintString("  -l                       Lex and output tokens\n");
	PrintString("  -p                       Parse and output ast\n");
	PrintString("  -r                       Resolve and output errors\n");
	PrintString("  -g                       Codegen and output C\n");
	exit(EXIT_FAILURE);
};

func bmain(files: UInt8**, fileCount: UInt, flags: UInt8) {
	var i = 0;
	while (i < fileCount) {
		var file = OpenFile(files[i], "r");
		_codeLength = file->readAll(&_code);
		file->close();
		
		var tempFlags = flags;
		
		_file = (UInt8*)files[i];
		Lex();
		if (flags & (UInt8)1 != (UInt8)0) { printTokens(); };
		flags = flags >> (UInt8)1;
		if (flags != (UInt8)0) {
			Parse();
			if (flags & (UInt8)1 != (UInt8)0) { printDeclarations(); };
		};
		
		flags = tempFlags;
		
		i = i + 1;
	};
	
	flags = flags >> (UInt8)2;
	if (flags == (UInt8)0) { return; };
	
	Resolve();
	flags = flags >> (UInt8)1;
	if (flags == (UInt8)0) { return; };
	
	Codegen();
};
