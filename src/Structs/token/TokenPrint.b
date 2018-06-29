func printToken(token: Token*) { _printToken(token, stdout); };
func printToken_error(token: Token*) { _printToken(token, stderr); };

func printTokens() {
	var i = 0;
	while (i < Buffer_getCount((Void**)_tokens)) {
		printToken(_tokens[i]);
		printf((char*)"\n");
		i = i + 1;
	};
};

func _printToken(token: Token*, stream: FILE*) {
	_printTokenKind(token->kind, stream);
	if (token->kind != .EOF) {
		fprintf(stream, (char*)" (");
		String_print(stream, token->string);
		fprintf(stream, (char*)")");
	};
};
