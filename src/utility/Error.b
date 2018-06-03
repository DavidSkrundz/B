func LexerError() {
	fprintf(stderr, (char*)"%s:%zu:%zu: ", _file, _line, _column);
	fprintf(stderr, (char*)"error: unexpected character ");
	if (isprint(*_code)) {
		fprintf(stderr, (char*)"'%c'%c", *_code, 10);
	} else {
		fprintf(stderr, (char*)"%02X%c", *_code, 10);
	};
	printUpToNewline((UInt8*)((UInt)_code - _column + 1));
	printErrorLocation((UInt8*)((UInt)_code - _column + 1), _column);
	exit(EXIT_FAILURE);
};

func printUpToNewline(string: UInt8*) {
	var firstNewline = (UInt8*)strchr((char*)string, (UInt8)10);
	if (firstNewline == NULL) {
		fprintf(stderr, (char*)"%s%c", string, 10);
	} else {
		fprintf(stderr, (char*)"%.*s%c", (int)(firstNewline - string), string, 10);
	};
};

func printErrorLocation(string: UInt8*, column: UInt) {
	column = column - 1;
	var i = 0;
	while (i < column) {
		if (string[i] == (UInt8)9) {
			fprintf(stderr, (char*)"%c", (UInt8)9);
		} else {
			fprintf(stderr, (char*)" ");
		};
		i = i + 1;
	};
	fprintf(stderr, (char*)"^%c", 10);
};
