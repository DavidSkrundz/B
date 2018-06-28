func printIdentifier(identifier: Token*) {
	printf((char*)"(identifier ");
	String_print(stdout, identifier->string);
	printf((char*)")");
};
