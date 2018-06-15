var _declarations: Declaration**;

func Parse() {
	var t = &_tokens;
	var loop = true;
	while (loop) {
		var declaration = parseDeclaration(t);
		if (declaration == NULL) {
			loop = false;
		} else {
			append((Void***)&_declarations, (Void*)declaration);
		};
	};
	
	if ((*_tokens)->kind != .EOF) {
		fprintf(stderr, (char*)"DEPRECATED ERROR - Unexpected token: ");
		printToken_error(*_tokens);
		fprintf(stderr, (char*)"%c%c", '\n', '\n');
		printDeclarations();
		exit(EXIT_FAILURE);
	};
};

func expectToken(kind: TokenKind) {
	if ((*_tokens)->kind != kind) {
		printDeclarations();
		ParserError(kind);
	};
	_tokens = (Token**)((UInt)_tokens + sizeof(Token*));
};

func expectKeyword(keyword: UInt8*) {
	if (isToken(.Identifier) && (*_tokens)->value == keyword) {
		_tokens = (Token**)((UInt)_tokens + sizeof(Token*));
	} else {
		printDeclarations();
		ParserKeywordError(keyword);
	};
};

func checkToken(kind: TokenKind): Bool {
	if ((*_tokens)->kind != kind) {
		return false;
	};
	_tokens = (Token**)((UInt)_tokens + sizeof(Token*));
	return true;
};

func checkKeyword(keyword: UInt8*): Bool {
	if (isToken(.Identifier) && (*_tokens)->value == keyword) {
		_tokens = (Token**)((UInt)_tokens + sizeof(Token*));
		return true;
	} else {
		return false;
	};
};

func isToken(kind: TokenKind): Bool {
	return (*_tokens)->kind == kind;
};

func isTokenKeyword(keyword: UInt8*): Bool {
	return isToken(.Identifier) && (*_tokens)->value == keyword;
};
