var _declarations: Declaration**;

func Parse() {
	while (checkToken(.EOF) == false) {
		append((Void***)&_declarations, (Void*)expectDeclaration());
	};
};

func advanceParser(amount: UInt) {
	_tokens = (Token**)((UInt)_tokens + amount * sizeof(Token*));
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
