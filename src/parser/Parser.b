var _declarations: Declaration**;

func Parse() {
	while (checkToken(.EOF) == false) {
		Buffer_append((Void***)&_declarations, (Void*)expectDeclaration());
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

func expectKeyword(keyword: String*) {
	if (isToken(.Identifier) && (*_tokens)->string == keyword) {
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

func checkKeyword(keyword: String*): Bool {
	if (isToken(.Identifier) && (*_tokens)->string == keyword) {
		_tokens = (Token**)((UInt)_tokens + sizeof(Token*));
		return true;
	} else {
		return false;
	};
};

func isToken(kind: TokenKind): Bool {
	return (*_tokens)->kind == kind;
};

func isTokenKeyword(keyword: String*): Bool {
	return isToken(.Identifier) && (*_tokens)->string == keyword;
};

func previousToken(): Token* {
	return *(Token**)((UInt)_tokens - sizeof(Token*));
};
