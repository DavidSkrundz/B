func printIdentifier(identifier: Identifier*) {
	printf((char*)"(identifier ");
	String_print(stdout, identifier->name);
	printf((char*)")");
};
