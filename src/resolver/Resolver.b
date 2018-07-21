var mainString: String*;

func Resolve() {
	mainString = String_init_literal("main");
	
	pushContext();
	InitBuiltinTypes();
	
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		resolveDeclaration(_declarations[i], true);
		i = i + 1;
	};
	
	restoreContext(rootContext);
	i = 0;
	while (i < Buffer_getCount((Void**)context->symbols)) {
		var symbol = context->symbols[i];
		if (symbol->name == mainString && symbol->type->kind == .Function) {
			symbol->useCount = symbol->useCount + 1;
		};
		i = i + 1;
	};
	warnUnusedVariables();
};

func warnUnusedVariables() {
	var i = 0;
	while (i < Buffer_getCount((Void**)context->symbols)) {
		var symbol = context->symbols[i];
		if (symbol->useCount == 0) {
			ResolverWarning2(symbol->pos, "unused symbol '", symbol->name->string, "'");
		};
		i = i + 1;
	};
};
