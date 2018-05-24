func parseIdentifier(tokens: Token***): Identifier* {
	if ((**tokens)->kind != TokenKind_Identifier) { return NULL; };
	var identifier = newIdentifier();
	identifier->name = (**tokens)->value;
	identifier->length = (**tokens)->length;
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	return identifier;
};
