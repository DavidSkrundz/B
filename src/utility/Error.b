func LexerError() {
	fprintf(stderr, (char*)"%s:%zu:%zu: ", _file, _line, _column);
	fprintf(stderr, (char*)"error: unexpected character ");
	if (isprint(*_code)) {
		fprintf(stderr, (char*)"'%c'\n", *_code);
	} else {
		fprintf(stderr, (char*)"%02X\n", *_code);
	};
	_printUpToNewline(_start);
	_printErrorLocation(_start, _column);
	exit(EXIT_FAILURE);
};

func ParserErrorTmp(string: UInt8*) {
	var token = *_tokens;
	var pos = token->pos;
	fprintf(stderr, (char*)"%s:%zu:%zu: ", pos->file, pos->line, pos->column);
	fprintf(stderr, (char*)"(tmp) error: %s\n", (char*)string);
	_printUpToNewline(pos->start);
	_printErrorLocation(pos->start, pos->column);
	exit(EXIT_FAILURE);
};

func ParserError(kind: TokenKind) {
	var token = *_tokens;
	var pos = token->pos;
	fprintf(stderr, (char*)"%s:%zu:%zu: ", pos->file, pos->line, pos->column);
	fprintf(stderr, (char*)"error: unexpected token '");
	printToken_error(token);
	fprintf(stderr, (char*)"' expecting '");
	_printTokenKind(kind, stderr);
	fprintf(stderr, (char*)"'\n");
	_printUpToNewline(pos->start);
	_printErrorLocation(pos->start, pos->column);
	exit(EXIT_FAILURE);
};

func ParserKeywordError(keyword: String*) {
	var token = *_tokens;
	var pos = token->pos;
	fprintf(stderr, (char*)"%s:%zu:%zu: ", pos->file, pos->line, pos->column);
	fprintf(stderr, (char*)"error: unexpected token '");
	printToken_error(token);
	fprintf(stderr, (char*)"' expecting keyword '");
	String_print(stderr, keyword);
	fprintf(stderr, (char*)"'\n");
	_printUpToNewline(pos->start);
	_printErrorLocation(pos->start, pos->column);
	exit(EXIT_FAILURE);
};

func ResolverError(pos: SrcPos*, message1: UInt8*, message2: UInt8*, message3: UInt8*) {
	fprintf(stderr, (char*)"%s:%zu:%zu: ", pos->file, pos->line, pos->column);
	fprintf(stderr, (char*)"error: %s%s%s\n", message1, message2, message3);
	_printUpToNewline(pos->start);
	_printErrorLocation(pos->start, pos->column);
	exit(EXIT_FAILURE);
};

func ProgrammingError(message: UInt8*) {
	fprintf(stderr, (char*)"Programming Error: %s\n", message);
	abort();
};

func _printUpToNewline(string: UInt8*) {
	var firstNewline = (UInt8*)strchr((char*)string, '\n');
	if (firstNewline == NULL) {
		fprintf(stderr, (char*)"%s\n", string);
	} else {
		fprintf(stderr, (char*)"%.*s\n", (int)(firstNewline - string), string);
	};
};

func _printErrorLocation(string: UInt8*, column: UInt) {
	column = column - 1;
	var i = 0;
	while (i < column) {
		if (string[i] == '\t') {
			fprintf(stderr, (char*)"\t");
		} else {
			fprintf(stderr, (char*)" ");
		};
		i = i + 1;
	};
	fprintf(stderr, (char*)"^\n");
};
