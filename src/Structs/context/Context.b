struct Context {
	var parent: Context*;
	var symbols: Symbol**;
};

func newContext(): Context* {
	return (Context*)Calloc(1, sizeof(Context));
};

func pushContext() {
	var newCtx = newContext();
	newCtx->parent = contexts->context;
	contexts->context = newCtx;
};

func popContext() {
	if (contexts->context == NULL) {
		ProgrammingError("popContext called with no Context present");
	};
	contexts->context = contexts->context->parent;
};

func stashContextToRoot(): Context* {
	var context = contexts->context;
	while (contexts->context->parent != NULL) { popContext(); };
	return context;
};

func restoreContextFromRoot(context: Context*) {
	contexts->context = context;
};

func registerSymbol(symbol: Symbol*) {
	var i = 0;
	while (i < Buffer_getCount((Void**)contexts->context->symbols)) {
		if (contexts->context->symbols[i]->name == symbol->name) {
			ResolverError(symbol->pos, "duplicate definition of '", symbol->name->string, "'");
		};
		i = i + 1;
	};
	var shadowedSymbol = findSymbol(symbol->name);
	if (shadowedSymbol != NULL) {
		shadowedSymbol->useCount = shadowedSymbol->useCount - 1;
		ResolverWarning(symbol->pos, "symbol '", symbol->name->string, "' shadows symbol at ", shadowedSymbol->pos);
	};
	Buffer_append((Void***)&contexts->context->symbols, (Void*)symbol);
};

func findSymbolByType(type: Type*): Symbol* {
	var currentContext = contexts->context;
	while (currentContext != NULL) {
		var i = 0;
		while (i < Buffer_getCount((Void**)currentContext->symbols)) {
			if (currentContext->symbols[i]->type == type && currentContext->symbols[i]->isType) {
				var sym = currentContext->symbols[i];
				sym->use();
				return sym;
			};
			i = i + 1;
		};
		currentContext = currentContext->parent;
	};
	return NULL;
};

func findSymbol(name: String*): Symbol* {
	var currentContext = contexts->context;
	while (currentContext != NULL) {
		var i = 0;
		while (i < Buffer_getCount((Void**)currentContext->symbols)) {
			if (currentContext->symbols[i]->name == name) {
				var sym = currentContext->symbols[i];
				sym->use();
				return sym;
			};
			i = i + 1;
		};
		currentContext = currentContext->parent;
	};
	return NULL;
};

func resolveSymbol(name: String*): Symbol* {
	var symbol = findSymbol(name);
	if (symbol != NULL) {
		symbol->use();
		return symbol;
	};
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		if (_declarations[i]->name->string == name) {
			var chainStash = stashContextChainToRoot();
			var contextStash = stashContextToRoot();
			resolveDeclaration(_declarations[i]);
			restoreContextFromRoot(contextStash);
			restoreContextChainFromRoot(chainStash);
			return resolveSymbol(name);
		};
		i = i + 1;
	};
	return NULL;
};
