func parseAttribute(tokens: Token***): Attribute* {
	var attribute: Attribute*;
	if (checkToken(.At)) {
		attribute = newAttribute();
		attribute->name = parseIdentifier(tokens);
	};
	return attribute;
};
