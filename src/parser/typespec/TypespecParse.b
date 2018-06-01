func parseTypespecIdentifier(tokens: Token***): TypespecIdentifier* {
	var typespecIdentifier = newTypespecIdentifier();
	typespecIdentifier->name = parseIdentifier(tokens);
	if (typespecIdentifier->name == NULL) { return (TypespecIdentifier*)NULL; };
	return typespecIdentifier;
};

func parseTypespec(tokens: Token***): Typespec* {
	var typespec = newTypespec();
	if ((**tokens)->kind == .Identifier) {
		typespec->kind = .Identifier;
		typespec->spec = (Void*)parseTypespecIdentifier(tokens);
	} else { return (Typespec*)NULL; };
	while (checkToken(.Star)) {
		var typespecPointer = newTypespecPointer();
		typespecPointer->base = typespec;
		typespec = newTypespec();
		typespec->kind = .Pointer;
		typespec->spec = (Void*)typespecPointer;
	};
	return typespec;
};
