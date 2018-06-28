struct Context {
	var names: Token**;
	var types: Type**;
};

func newContext(): Context* {
	return (Context*)xcalloc(1, sizeof(Context));
};

func addTo(context: Context*, name: Token*, type: Type*) {
	var i = 0;
	while (i < Buffer_getCount((Void**)context->names)) {
		if (context->names[i]->string == name->string) {
			ResolverError(context->names[i]->pos, "duplicate definition of '", name->string->string, "'");
		};
		i = i + 1;
	};
	Buffer_append((Void***)&context->names, (Void*)name);
	Buffer_append((Void***)&context->types, (Void*)type);
};
