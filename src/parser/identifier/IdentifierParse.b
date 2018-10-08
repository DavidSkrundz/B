func parseIdentifier(): Token* {
	var token = *_tokens;
	return checkToken(.Identifier) ? token : NULL;
};

func expectIdentifier(): Token* {
	var token = *_tokens;
	expectToken(.Identifier);
	return token;
};
