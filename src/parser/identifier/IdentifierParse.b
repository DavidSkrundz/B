func parseIdentifier(tokens: Token***): Identifier* {
	if ((**tokens)->kind != .Identifier) { return NULL; };
	var identifier = newIdentifier();
	identifier->pos = (**tokens)->pos;
	identifier->name = (**tokens)->value;
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	return identifier;
};

func expectIdentifier(): Identifier* {
	var token = *_tokens;
	expectToken(.Identifier);
	var identifier = newIdentifier();
	identifier->pos = token->pos;
	identifier->name = token->value;
	return identifier;
};
