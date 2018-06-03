func parseAttribute(tokens: Token***): Attribute* {
	var attribute: Attribute*;
	if (checkToken(.At)) {
		attribute = newAttribute();
		attribute->name = expectIdentifier();
	};
	return attribute;
};
