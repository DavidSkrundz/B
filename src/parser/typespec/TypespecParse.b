func parseTypespecIdentifier(tokens: Token***): TypespecIdentifier* {
	var typespecIdentifier = newTypespecIdentifier();
	typespecIdentifier->name = parseIdentifier(tokens);
	if (typespecIdentifier->name == NULL) { return (TypespecIdentifier*)NULL; };
	return typespecIdentifier;
};

func parseTypespec(tokens: Token***): Typespec* {
	var typespec = newTypespec();
	if ((**tokens)->kind == TokenKind_Identifier) {
		typespec->kind = TypespecKind_Identifier;
		typespec->spec = (Void*)parseTypespecIdentifier(tokens);
	} else { return (Typespec*)NULL; };
	while (checkToken(TokenKind_Star)) {
		var typespecPointer = newTypespecPointer();
		typespecPointer->base = typespec;
		typespec = newTypespec();
		typespec->kind = TypespecKind_Pointer;
		typespec->spec = (Void*)typespecPointer;
	};
	return typespec;
};
