struct Token {
	var kind: TokenKind;
	var pos: SrcPos*;
	var string: String*;
};

func newToken(): Token* {
	return (Token*)xcalloc(1, sizeof(Token));
};
