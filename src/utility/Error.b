func LexerError() {
	fprintf(stderr, (char*)"%s:%zu:%zu: ", _file, _line, _column);
	fprintf(stderr, (char*)"error: unexpected character ");
	if (isprint(*_code)) {
		fprintf(stderr, (char*)"'%c'%c", *_code, '\n');
	} else {
		fprintf(stderr, (char*)"%02X%c", *_code, '\n');
	};
	_printUpToNewline(_start);
	_printErrorLocation(_start, _column);
	exit(EXIT_FAILURE);
};

func ParserError(kind: TokenKind) {
	var token = *_tokens;
	var pos = token->pos;
	fprintf(stderr, (char*)"%s:%zu:%zu: ", pos->file, pos->line, pos->column);
	fprintf(stderr, (char*)"error: unexpected token '");
	printToken_error(token);
	fprintf(stderr, (char*)"' expecting '");
	printTokenKind_error(kind);
	fprintf(stderr, (char*)"'%c", '\n');
	_printUpToNewline(pos->start);
	_printErrorLocation(pos->start, pos->column);
	exit(EXIT_FAILURE);
};

func ParserKeywordError(keyword: UInt8*) {
	var token = *_tokens;
	var pos = token->pos;
	fprintf(stderr, (char*)"%s:%zu:%zu: ", pos->file, pos->line, pos->column);
	fprintf(stderr, (char*)"error: unexpected token '");
	printToken_error(token);
	fprintf(stderr, (char*)"' expecting keyword '%s'%c", keyword, '\n');
	_printUpToNewline(pos->start);
	_printErrorLocation(pos->start, pos->column);
	exit(EXIT_FAILURE);
};

func _printUpToNewline(string: UInt8*) {
	var firstNewline = (UInt8*)strchr((char*)string, '\n');
	if (firstNewline == NULL) {
		fprintf(stderr, (char*)"%s%c", string, '\n');
	} else {
		fprintf(stderr, (char*)"%.*s%c", (int)(firstNewline - string), string, '\n');
	};
};

func _printErrorLocation(string: UInt8*, column: UInt) {
	column = column - 1;
	var i = 0;
	while (i < column) {
		if (string[i] == '\t') {
			fprintf(stderr, (char*)"%c", '\t');
		} else {
			fprintf(stderr, (char*)" ");
		};
		i = i + 1;
	};
	fprintf(stderr, (char*)"^%c", '\n');
};
