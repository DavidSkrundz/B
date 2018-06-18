func expectTypespecIdentifier(): TypespecIdentifier* {
	var typespecIdentifier = newTypespecIdentifier();
	typespecIdentifier->name = expectIdentifier();
	return typespecIdentifier;
};

func parseTypespec(tokens: Token***): Typespec* {
	var typespec = newTypespec();
	if (isToken(.Identifier)) {
		typespec->pos = _tokens[0]->pos;
		typespec->kind = .Identifier;
		typespec->spec = (Void*)expectTypespecIdentifier();
	} else { return (Typespec*)NULL; };
	while (checkToken(.Star)) {
		var typespecPointer = newTypespecPointer();
		typespecPointer->base = typespec;
		typespec = newTypespec();
		typespec->pos = previousToken()->pos;
		typespec->kind = .Pointer;
		typespec->spec = (Void*)typespecPointer;
	};
	return typespec;
};

func expectTypespec(): Typespec* {
	var typespec = newTypespec();
	typespec->pos = _tokens[0]->pos;
	typespec->kind = .Identifier;
	typespec->spec = (Void*)expectTypespecIdentifier();
	while (checkToken(.Star)) {
		var typespecPointer = newTypespecPointer();
		typespecPointer->base = typespec;
		typespec = newTypespec();
		typespec->pos = previousToken()->pos;
		typespec->kind = .Pointer;
		typespec->spec = (Void*)typespecPointer;
	};
	return typespec;
};
