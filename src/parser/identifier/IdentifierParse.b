func parseIdentifier(tokens: Token***): Identifier* {
	if ((**tokens)->kind != .Identifier) { return NULL; };
	var identifier = newIdentifier();
	identifier->pos = (**tokens)->pos;
	identifier->name = intern((**tokens)->string->string, (**tokens)->string->length);
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	return identifier;
};

func expectIdentifier(): Identifier* {
	var token = *_tokens;
	expectToken(.Identifier);
	var identifier = newIdentifier();
	identifier->pos = token->pos;
	identifier->name = intern(token->string->string, token->string->length);
	return identifier;
};
