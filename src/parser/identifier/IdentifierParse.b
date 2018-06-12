func parseIdentifier(tokens: Token***): Identifier* {
	if ((**tokens)->kind != .Identifier) { return NULL; };
	var identifier = newIdentifier();
	identifier->name = (**tokens)->value;
	identifier->length = stringLength((**tokens)->value);
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	return identifier;
};

func expectIdentifier(): Identifier* {
	var token = *_tokens;
	expectToken(.Identifier);
	var identifier = newIdentifier();
	identifier->name = token->value;
	identifier->length = stringLength(token->value);
	return identifier;
};
