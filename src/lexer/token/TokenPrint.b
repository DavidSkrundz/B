func printToken(token: Token*) { _printToken(token, stdout); };
func printToken_error(token: Token*) { _printToken(token, stderr); };

func printTokens(tokens: Token**, count: UInt) {
	var i = 0;
	while (i < count) {
		printToken(tokens[i]);
		printf((char*)"%c", 10);
		i = i + 1;
	};
};

func _printToken(token: Token*, stream: FILE*) {
	if (token == NULL) {
		fprintf(stderr, (char*)"NULL Token");
		abort();
	};
	if (token->kind == TokenKind_EOF) {
		fprintf(stream, (char*)"EOF");
	} else if (token->kind == TokenKind_NULL) {
		fprintf(stream, (char*)"NULL");
	} else if (token->kind == TokenKind_Sizeof) {
		fprintf(stream, (char*)"SIZEOF");
	} else if (token->kind == TokenKind_Struct) {
		fprintf(stream, (char*)"STRUCT");
	} else if (token->kind == TokenKind_Var) {
		fprintf(stream, (char*)"VAR");
	} else if (token->kind == TokenKind_Func) {
		fprintf(stream, (char*)"FUNC");
	} else if (token->kind == TokenKind_If) {
		fprintf(stream, (char*)"IF");
	} else if (token->kind == TokenKind_Else) {
		fprintf(stream, (char*)"ELSE");
	} else if (token->kind == TokenKind_While) {
		fprintf(stream, (char*)"WHILE");
	} else if (token->kind == TokenKind_Return) {
		fprintf(stream, (char*)"RETURN");
	} else if (token->kind == TokenKind_Comma) {
		fprintf(stream, (char*)"COMMA (,)");
	} else if (token->kind == TokenKind_Colon) {
		fprintf(stream, (char*)"COLON (:)");
	} else if (token->kind == TokenKind_Semicolon) {
		fprintf(stream, (char*)"SEMICOLON (;)");
	} else if (token->kind == TokenKind_OpenCurly) {
		fprintf(stream, (char*)"OPENCURLY ({)");
	} else if (token->kind == TokenKind_CloseCurly) {
		fprintf(stream, (char*)"CLOSECURLY (})");
	} else if (token->kind == TokenKind_OpenBracket) {
		fprintf(stream, (char*)"OPENBRACKET ([)");
	} else if (token->kind == TokenKind_CloseBracket) {
		fprintf(stream, (char*)"CLOSEBRACKET (])");
	} else if (token->kind == TokenKind_OpenParenthesis) {
		fprintf(stream, (char*)"OPENPARENTHESIS (()");
	} else if (token->kind == TokenKind_CloseParenthesis) {
		fprintf(stream, (char*)"CLOSEPARENTHESIS ())");
	} else if (token->kind == TokenKind_At) {
		fprintf(stream, (char*)"AT (@)");
	} else if (token->kind == TokenKind_Star) {
		fprintf(stream, (char*)"STAR (*)");
	} else if (token->kind == TokenKind_And) {
		fprintf(stream, (char*)"AND (&)");
	} else if (token->kind == TokenKind_Plus) {
		fprintf(stream, (char*)"PLUS (+)");
	} else if (token->kind == TokenKind_Minus) {
		fprintf(stream, (char*)"MINUS (-)");
	} else if (token->kind == TokenKind_Slash) {
		fprintf(stream, (char*)"SLASH (/)");
	} else if (token->kind == TokenKind_And) {
		fprintf(stream, (char*)"AND (&)");
	} else if (token->kind == TokenKind_AndAnd) {
		fprintf(stream, (char*)"AND (&&)");
	} else if (token->kind == TokenKind_OrOr) {
		fprintf(stream, (char*)"OR (||)");
	} else if (token->kind == TokenKind_Not) {
		fprintf(stream, (char*)"NOT (!)");
	} else if (token->kind == TokenKind_Assign) {
		fprintf(stream, (char*)"ASSIGN (=)");
	} else if (token->kind == TokenKind_Ellipses) {
		fprintf(stream, (char*)"ELLIPSES (...)");
	} else if (token->kind == TokenKind_Arrow) {
		fprintf(stream, (char*)"ARROW (->)");
	} else if (token->kind == TokenKind_Equal) {
		fprintf(stream, (char*)"EQUAL (==)");
	} else if (token->kind == TokenKind_LessThan) {
		fprintf(stream, (char*)"LESSTHAN (<)");
	} else if (token->kind == TokenKind_LessThanEqual) {
		fprintf(stream, (char*)"LESSTHANEQUAL (<=)");
	} else if (token->kind == TokenKind_NotEqual) {
		fprintf(stream, (char*)"NOTEQUAL (!=)");
	} else if (token->kind == TokenKind_Identifier) {
		fprintf(stream, (char*)"IDENTIFIER (%.*s)", (int)token->length, token->value);
	} else if (token->kind == TokenKind_BooleanLiteral) {
		fprintf(stream, (char*)"BOOLEAN (%.*s)", (int)token->length, token->value);
	} else if (token->kind == TokenKind_IntegerLiteral) {
		fprintf(stream, (char*)"INTEGER (%.*s)", (int)token->length, token->value);
	} else if (token->kind == TokenKind_StringLiteral) {
		fprintf(stream, (char*)"STRING (%.*s)", (int)token->length, token->value);
	} else {
		fprintf(stderr, (char*)"Unknown token kind: %zd%c", token->kind, 10);
		abort();
	};;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
};
