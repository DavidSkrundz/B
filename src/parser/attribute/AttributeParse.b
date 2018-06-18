func parseAttribute(tokens: Token***): Attribute* {
	var attribute: Attribute*;
	if (checkToken(.At)) {
		attribute = newAttribute();
		attribute->pos = previousToken()->pos;
		attribute->name = expectIdentifier();
		if (checkToken(.OpenParenthesis)) {
			append((Void***)&attribute->parameters, (Void*)expectIdentifier());
			while (checkToken(.Comma)) {
				append((Void***)&attribute->parameters, (Void*)expectIdentifier());
			};
			expectToken(.CloseParenthesis);
		};
	};
	return attribute;
};
