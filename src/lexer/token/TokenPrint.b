func printToken(token: Token*) { _printToken(token, stdout); };
func printToken_error(token: Token*) { _printToken(token, stderr); };

func printTokens() {
	var i = 0;
	while (i < bufferCount((Void**)_tokens)) {
		printToken(_tokens[i]);
		printf((char*)"%c", 10);
		i = i + 1;
	};
};

func _printToken(token: Token*, stream: FILE*) {
	if (token == NULL) {
		fprintf(stderr, (char*)"NULL Token");
		abort();
	};
	if (token->kind == .EOF) {
		fprintf(stream, (char*)"EOF");
	} else if (token->kind == ._NULL) {
		fprintf(stream, (char*)"NULL");
	} else if (token->kind == .Sizeof) {
		fprintf(stream, (char*)"SIZEOF");
	} else if (token->kind == .Offsetof) {
		fprintf(stream, (char*)"OFFSETOF");
	} else if (token->kind == .Struct) {
		fprintf(stream, (char*)"STRUCT");
	} else if (token->kind == .Enum) {
		fprintf(stream, (char*)"ENUM");
	} else if (token->kind == .Var) {
		fprintf(stream, (char*)"VAR");
	} else if (token->kind == .Func) {
		fprintf(stream, (char*)"FUNC");
	} else if (token->kind == .If) {
		fprintf(stream, (char*)"IF");
	} else if (token->kind == .Else) {
		fprintf(stream, (char*)"ELSE");
	} else if (token->kind == .While) {
		fprintf(stream, (char*)"WHILE");
	} else if (token->kind == .Return) {
		fprintf(stream, (char*)"RETURN");
	} else if (token->kind == .Case) {
		fprintf(stream, (char*)"CASE");
	} else if (token->kind == .Comma) {
		fprintf(stream, (char*)"COMMA (,)");
	} else if (token->kind == .Colon) {
		fprintf(stream, (char*)"COLON (:)");
	} else if (token->kind == .Semicolon) {
		fprintf(stream, (char*)"SEMICOLON (;)");
	} else if (token->kind == .OpenCurly) {
		fprintf(stream, (char*)"OPENCURLY ({)");
	} else if (token->kind == .CloseCurly) {
		fprintf(stream, (char*)"CLOSECURLY (})");
	} else if (token->kind == .OpenBracket) {
		fprintf(stream, (char*)"OPENBRACKET ([)");
	} else if (token->kind == .CloseBracket) {
		fprintf(stream, (char*)"CLOSEBRACKET (])");
	} else if (token->kind == .OpenParenthesis) {
		fprintf(stream, (char*)"OPENPARENTHESIS (()");
	} else if (token->kind == .CloseParenthesis) {
		fprintf(stream, (char*)"CLOSEPARENTHESIS ())");
	} else if (token->kind == .At) {
		fprintf(stream, (char*)"AT (@)");
	} else if (token->kind == .Star) {
		fprintf(stream, (char*)"STAR (*)");
	} else if (token->kind == .And) {
		fprintf(stream, (char*)"AND (&)");
	} else if (token->kind == .Plus) {
		fprintf(stream, (char*)"PLUS (+)");
	} else if (token->kind == .Minus) {
		fprintf(stream, (char*)"MINUS (-)");
	} else if (token->kind == .Slash) {
		fprintf(stream, (char*)"SLASH (/)");
	} else if (token->kind == .And) {
		fprintf(stream, (char*)"AND (&)");
	} else if (token->kind == .AndAnd) {
		fprintf(stream, (char*)"AND (&&)");
	} else if (token->kind == .OrOr) {
		fprintf(stream, (char*)"OR (||)");
	} else if (token->kind == .Not) {
		fprintf(stream, (char*)"NOT (!)");
	} else if (token->kind == .Assign) {
		fprintf(stream, (char*)"ASSIGN (=)");
	} else if (token->kind == .Ellipses) {
		fprintf(stream, (char*)"ELLIPSES (...)");
	} else if (token->kind == .Arrow) {
		fprintf(stream, (char*)"ARROW (->)");
	} else if (token->kind == .Dot) {
		fprintf(stream, (char*)"DOT (.)");
	} else if (token->kind == .Equal) {
		fprintf(stream, (char*)"EQUAL (==)");
	} else if (token->kind == .LessThan) {
		fprintf(stream, (char*)"LESSTHAN (<)");
	} else if (token->kind == .LessThanEqual) {
		fprintf(stream, (char*)"LESSTHANEQUAL (<=)");
	} else if (token->kind == .NotEqual) {
		fprintf(stream, (char*)"NOTEQUAL (!=)");
	} else if (token->kind == .Identifier) {
		fprintf(stream, (char*)"IDENTIFIER (%.*s)", (int)token->length, token->value);
	} else if (token->kind == .BooleanLiteral) {
		fprintf(stream, (char*)"BOOLEAN (%.*s)", (int)token->length, token->value);
	} else if (token->kind == .IntegerLiteral) {
		fprintf(stream, (char*)"INTEGER (%.*s)", (int)token->length, token->value);
	} else if (token->kind == .CharacterLiteral) {
		fprintf(stream, (char*)"CHARACTER (%.*s)", (int)token->length, token->value);
	} else if (token->kind == .StringLiteral) {
		fprintf(stream, (char*)"STRING (%.*s)", (int)token->length, token->value);
	} else {
		fprintf(stderr, (char*)"Unknown token kind: %u%c", token->kind, 10);
		abort();
	};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
};
