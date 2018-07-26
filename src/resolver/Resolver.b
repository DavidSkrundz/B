var mainString: String*;

func Resolve() {
	mainString = String_init_literal("main");
	
	pushContextChain();
	pushContext();
	InitBuiltinTypes();
	
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		var chainStash = stashContextChainToRoot();
		var contextStash = stashContextToRoot();
		resolveDeclaration(_declarations[i]);
		restoreContextFromRoot(contextStash);
		restoreContextChainFromRoot(chainStash);
		i = i + 1;
	};
	
	i = 0;
	while (i < Buffer_getCount((Void**)contexts->context->symbols)) {
		var symbol = contexts->context->symbols[i];
		if (symbol->name == mainString && symbol->type->kind == .Function) {
			Symbol_use(symbol);
		};
		i = i + 1;
	};
	warnUnusedVariables();
};

func warnUnusedVariables() {
	var i = 0;
	while (i < Buffer_getCount((Void**)contexts->context->symbols)) {
		var symbol = contexts->context->symbols[i];
		if (Symbol_unused(symbol)) {
			ResolverWarning2(symbol->pos, "unused symbol '", symbol->name->string, "'");
		};
		i = i + 1;
	};
};
