struct Context {
	var names: Identifier**;
	var types: Type**;
};

func newContext(): Context* {
	return (Context*)xcalloc(1, sizeof(Context));
};

func addTo(context: Context*, name: Identifier*, type: Type*) {
	var i = 0;
	while (i < Buffer_getCount((Void**)context->names)) {
		if (context->names[i]->name == name->name) {
			ResolverError(name->pos, "duplicate definition of '", name->name->string, "'");
		};
		i = i + 1;
	};
	Buffer_append((Void***)&context->names, (Void*)name);
	Buffer_append((Void***)&context->types, (Void*)type);
};
