func printAttribute(attribute: Attribute*) {
	printf((char*)"@%.*s(", (int)attribute->name->length, attribute->name->name);
	var i = 0;
	while (i < bufferCount((Void**)attribute->parameters)) {
		printf((char*)"%.*s", (int)attribute->parameters[i]->length, attribute->parameters[i]->name);
		i = i + 1;
		if (i + 1 <= bufferCount((Void**)attribute->parameters)) {
			printf((char*)", ");
		};
	};
	printf((char*)")%c", 10);
};
