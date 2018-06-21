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
		if (context->names[i]->name == name->name) {
			ResolverError(name->pos, "duplicate definition of '", name->name, "'");
		};
		i = i + 1;
	};
	append((Void***)&context->names, (Void*)name);
	append((Void***)&context->types, (Void*)type);
};
