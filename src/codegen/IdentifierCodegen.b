func codegenIdentifier(identifier: Identifier*) {
	printf((char*)"%.*s", (int)identifier->length, identifier->name);
};
