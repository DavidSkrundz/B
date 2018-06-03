struct Token {
	var kind: TokenKind;
	var value: UInt8*;
	var length: UInt;
	var pos: SrcPos*;
};

func newToken(): Token* {
	return (Token*)xcalloc(1, sizeof(Token));
};
