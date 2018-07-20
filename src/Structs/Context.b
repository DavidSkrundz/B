struct Context {
	var parent: Context*;
	var symbols: Symbol**;
};

var rootContext: Context*;
var context: Context*;

func pushContext() {
	var newContext = (Context*)xcalloc(1, sizeof(Context));
	newContext->parent = context;
	context = newContext;
	if (rootContext == NULL) {
		rootContext = context;
	};
};

func popContext() {
	if (context == rootContext) {
		ProgrammingError("popContext called on root");
	};
	context = context->parent;
};

func stashContext(): Context* {
	var stash = context;
	context = rootContext;
	return stash;
};

func restoreContext(stash: Context*) {
	context = stash;
};

func registerGlobalSymbol(symbol: Symbol*) {
	var i = 0;
	while (i < Buffer_getCount((Void**)rootContext->symbols)) {
		if (rootContext->symbols[i]->name == symbol->name) {
			ResolverError(rootContext->symbols[i]->pos, "duplicate definition of '", symbol->name->string, "'");
		};
		i = i + 1;
	};
	Buffer_append((Void***)&rootContext->symbols, (Void*)symbol);
};

func registerSymbol(symbol: Symbol*) {
	var i = 0;
	while (i < Buffer_getCount((Void**)context->symbols)) {
		if (context->symbols[i]->name == symbol->name) {
			ResolverError(symbol->pos, "duplicate definition of '", symbol->name->string, "'");
		};
		i = i + 1;
	};
	var shadowedSymbol = findSymbol(symbol->name);
	if (shadowedSymbol != NULL) {
		shadowedSymbol->useCount = shadowedSymbol->useCount - 1;
		ResolverWarning(symbol->pos, "symbol '", symbol->name->string, "' shadows symbol at ", shadowedSymbol->pos);
	};
	Buffer_append((Void***)&context->symbols, (Void*)symbol);
};

func findSymbol(name: String*): Symbol* {
	var currentContext = context;
	while (currentContext != NULL) {
		var i = 0;
		while (i < Buffer_getCount((Void**)currentContext->symbols)) {
			if (currentContext->symbols[i]->name == name) {
				var sym = currentContext->symbols[i];
				sym->useCount = sym->useCount + 1;
				return sym;
			};
			i = i + 1;
		};
		currentContext = currentContext->parent;
	};
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		if (_declarations[i]->name->string == name) {
			resolveDeclaration(_declarations[i], true);
			return findSymbol(name);
		};
		i = i + 1;
	};
	return NULL;
};
