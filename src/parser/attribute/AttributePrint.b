func printAttribute(attribute: Attribute*) {
	printf((char*)"@%.*s%c", (int)attribute->name->length, attribute->name->name, 10);
};
