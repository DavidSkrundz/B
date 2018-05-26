struct Token {
	var kind: UInt;
	var value: UInt8*;
	var length: UInt;
};

func newToken(): Token* {
	return (Token*)xcalloc(1, sizeof(Token));
};
