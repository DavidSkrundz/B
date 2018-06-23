func printAttribute(attribute: Attribute*) {
	printf((char*)"@%s(", attribute->name->name);
	var i = 0;
	while (i < Buffer_getCount((Void**)attribute->parameters)) {
		printf((char*)"%s", attribute->parameters[i]->name);
		i = i + 1;
		if (i + 1 <= Buffer_getCount((Void**)attribute->parameters)) {
			printf((char*)", ");
		};
	};
	printf((char*)")\n");
};
