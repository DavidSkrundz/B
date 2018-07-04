struct Context {
	var parent: Context*;
	var symbols: Symbol**;
};

var context: Context*;

func pushContext() {
	var newContext = (Context*)xcalloc(1, sizeof(Context));
	newContext->parent = context;
	context = newContext;
};

func popContext() {
	if (context->parent == NULL) {
		ProgrammingError("popContext called on root");
	};
	context = context->parent;
};

func registerSymbol(symbol: Symbol*) {
	var i = 0;
	while (i < Buffer_getCount((Void**)context->symbols)) {
		if (context->symbols[i]->name == symbol->name) {
			ResolverError(context->symbols[i]->pos, "duplicate definition of '", symbol->name->string, "'");
		};
		i = i + 1;
	};
	Buffer_append((Void***)&context->symbols, (Void*)symbol);
};

func findSymbol(name: String*): Symbol* {
	var currentContext = context;
	while (currentContext != NULL) {
		var i = 0;
		while (i < Buffer_getCount((Void**)currentContext->symbols)) {
			if (currentContext->symbols[i]->name == name) {
				return currentContext->symbols[i];
			};
			i = i + 1;
		};
		currentContext = currentContext->parent;
	};
	return NULL;
};
