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
		fprintf(stderr, (char*)"Unexpected token: ");
		printToken_error(*_tokens);
		fprintf(stderr, (char*)"%c%c", 10, 10);
		printDeclarations();
		exit(EXIT_FAILURE);
	};
};

func expectToken(kind: TokenKind) {
	if ((*_tokens)->kind != kind) {
		printDeclarations();
		fprintf(stderr, (char*)"%c", 10);
		fprintf(stderr, (char*)"Unexpected token: ");
		printToken_error(*_tokens);
		fprintf(stderr, (char*)", expecting %u%c", kind, 10);
		exit(EXIT_FAILURE);
	};
	_tokens = (Token**)((UInt)_tokens + sizeof(Token*));
};

func checkToken(kind: TokenKind): Bool {
	if ((*_tokens)->kind != kind) {
		return false;
	};
	_tokens = (Token**)((UInt)_tokens + sizeof(Token*));
	return true;
};

func isToken(kind: TokenKind): Bool {
	return (*_tokens)->kind == kind;
};
