func parseAttribute(tokens: Token***): Attribute* {
	if ((**tokens)->kind != TokenKind_At) { return (Attribute*)NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	var attribute = newAttribute();
	attribute->name = parseIdentifier(tokens);
	return attribute;
};
