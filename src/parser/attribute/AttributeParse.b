func parseAttribute(tokens: Token***): Attribute* {
	var attribute: Attribute*;
	if (checkToken(TokenKind_At)) {
		attribute = newAttribute();
		attribute->name = parseIdentifier(tokens);
	};
	return attribute;
};
