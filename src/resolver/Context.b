struct OldContext {
	var names: Token**;
	var types: Type**;
};

func newOldContext(): OldContext* {
	return (OldContext*)xcalloc(1, sizeof(OldContext));
};

func addTo(OldContext: OldContext*, name: Token*, type: Type*) {
	var i = 0;
	while (i < Buffer_getCount((Void**)OldContext->names)) {
		if (OldContext->names[i]->string == name->string) {
			ResolverError(OldContext->names[i]->pos, "duplicate definition of '", name->string->string, "'");
		};
		i = i + 1;
	};
	Buffer_append((Void***)&OldContext->names, (Void*)name);
	Buffer_append((Void***)&OldContext->types, (Void*)type);
};
