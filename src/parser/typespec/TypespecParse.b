func parseTypespecIdentifier(): TypespecIdentifier* {
	var typespecIdentifier = newTypespecIdentifier();
	typespecIdentifier->name = expectIdentifier();
	return typespecIdentifier;
};

func parseTypespec(tokens: Token***): Typespec* {
	var typespec = newTypespec();
	if (isToken(.Identifier)) {
		typespec->kind = .Identifier;
		typespec->spec = (Void*)parseTypespecIdentifier();
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
