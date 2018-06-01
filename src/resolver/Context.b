struct Context {
	var names: Identifier**;
	var types: Type**;
};

func newContext(): Context* {
	return (Context*)xcalloc(1, sizeof(Context));
};

func addTo(context: Context*, name: Identifier*, type: Type*) {
	var i = 0;
	while (i < bufferCount((Void**)context->names)) {
		if (name->length == context->names[i]->length) {
			if (strncmp((char*)context->names[i]->name, (char*)name->name, name->length) == (int)0) {
				fprintf(stderr, (char*)"Duplicate definition of %.*s%c", (int)name->length, name->name, 10);
				exit(EXIT_FAILURE);
			};
		};
		i = i + 1;
	};
	append((Void***)&context->names, (Void*)name);
	append((Void***)&context->types, (Void*)type);
};