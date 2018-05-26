var _declarations: Declaration**;
var _declarationCount = 0;

func Parse() {
	InitTypespecKinds();
	InitDeclarationKinds();
	InitDeclarationStates();
	InitStatementKinds();
	InitExpressionKinds();
	
	_declarations = (Declaration**)xcalloc(_tokenCount, sizeof(Declaration*));
	_declarationCount = 0;
	
	var t = &_tokens;
	var loop = true;
	while (loop) {
		var declaration = parseDeclaration(t);
		if (declaration == NULL) {
			loop = false;
		} else {
			_declarations[_declarationCount] = declaration;
			_declarationCount = _declarationCount + 1;
		};
	};
	
	if ((*_tokens)->kind != TokenKind_EOF) {
		fprintf(stderr, (char*)"Unexpected token: ");
		printToken_error(*_tokens);
		fprintf(stderr, (char*)"%c%c", 10, 10);
		printDeclarations(_declarations, _declarationCount);
		exit(EXIT_FAILURE);
	};
};

func expectToken(kind: UInt) {
	if ((*_tokens)->kind != kind) {
		printDeclarations(_declarations, _declarationCount);
		fprintf(stderr, (char*)"%c", 10);
		fprintf(stderr, (char*)"Unexpected token: ");
		printToken_error(*_tokens);
		fprintf(stderr, (char*)", expecting %zu%c", kind, 10);
		exit(EXIT_FAILURE);
	};
	_tokens = (Token**)((UInt)_tokens + sizeof(Token*));
};

func checkToken(kind: UInt): Bool {
	if ((*_tokens)->kind != kind) {
		return false;
	};
	_tokens = (Token**)((UInt)_tokens + sizeof(Token*));
	return true;
};
