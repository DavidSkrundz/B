func parseIdentifier(): Token* {
	var token = *_tokens;
	if (checkToken(.Identifier)) { return token; };
	return NULL;
};

func expectIdentifier(): Token* {
	var token = *_tokens;
	expectToken(.Identifier);
	return token;
};
