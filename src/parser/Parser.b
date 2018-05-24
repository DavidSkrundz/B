var _declarations: Declaration**;
var _declarationCount = (UInt)0;

func Parse() {
	InitTypespecKinds();
	InitDeclarationKinds();
	InitDeclarationStates();
	InitStatementKinds();
	InitExpressionKinds();
	
	_declarations = (Declaration**)xcalloc(_tokenCount, sizeof(Declaration*));
	_declarationCount = (UInt)0;
	
	var t = &_tokens;
	var loop = true;
	while (loop) {
		var declaration = parseDeclaration(t);
		if (declaration == NULL) {
			loop = false;
		} else {
			_declarations[_declarationCount] = declaration;
			_declarationCount = _declarationCount + (UInt)1;
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
