func printAttribute(attribute: Attribute*) {
	printf((char*)"@%s(", attribute->name->string->string);
	var i = 0;
	while (i < Buffer_getCount((Void**)attribute->parameters)) {
		String_print(stdout, attribute->parameters[i]->string);
		i = i + 1;
		if (i + 1 <= Buffer_getCount((Void**)attribute->parameters)) {
			printf((char*)", ");
		};
	};
	printf((char*)")\n");
};
