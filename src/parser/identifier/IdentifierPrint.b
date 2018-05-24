func printIdentifier(identifier: Identifier*) {
	printf((char*)"(identifier %.*s)", (int)identifier->length, (char*)identifier->name);
};
