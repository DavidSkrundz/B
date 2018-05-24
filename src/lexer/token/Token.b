struct Token {
	var kind: UInt;
	var value: UInt8*;
	var length: UInt;
};

func newToken(): Token* {
	return (Token*)xcalloc((UInt)1, sizeof(Token));
};
