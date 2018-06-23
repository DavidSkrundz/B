func parseAttribute(tokens: Token***): Attribute* {
	var attribute: Attribute*;
	if (checkToken(.At)) {
		attribute = newAttribute();
		attribute->pos = previousToken()->pos;
		attribute->name = expectIdentifier();
		if (checkToken(.OpenParenthesis)) {
			Buffer_append((Void***)&attribute->parameters, (Void*)expectIdentifier());
			while (checkToken(.Comma)) {
				Buffer_append((Void***)&attribute->parameters, (Void*)expectIdentifier());
			};
			expectToken(.CloseParenthesis);
		};
	};
	return attribute;
};
