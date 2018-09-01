func resolveDeclarationVar(declaration: DeclarationVar*, name: Token*): Symbol* {
	var type: Type*;
	if (declaration->type != NULL) {
		type = resolveTypespec(declaration->type);
	};
	if (declaration->value != NULL) {
		var expressionType = resolveExpression(declaration->value, type);
		if (type == NULL) { type = expressionType; };
	};
	var symbol = Symbol_init();
	symbol->name = name->string;
	symbol->type = type;
	symbol->pos = name->pos;
	registerSymbol(symbol);
	return symbol;
};

func resolveDeclarationFuncArg(argument: DeclarationFuncArg*): Type* {
	argument->resolvedType = resolveTypespec(argument->type);
	return argument->resolvedType;
};

func resolveDeclarationFuncArgs(args: DeclarationFuncArgs*): Type** {
	var argumentTypes: Type**;
	var i = 0;
	while (i < Buffer_getCount((Void**)args->args)) {
		Buffer_append((Void***)&argumentTypes, (Void*)resolveDeclarationFuncArg(args->args[i]));
		i = i + 1;
	};
	return argumentTypes;
};

func resolveDeclarationFunc(declaration: DeclarationFunc*, name: Token*): Symbol* {
	var argumentTypes = resolveDeclarationFuncArgs(declaration->args);
	var returnType = TypeVoid;
	if (declaration->returnType != NULL) {
		returnType = resolveTypespec(declaration->returnType);
	};
	var type = resolveTypeFunction(returnType, argumentTypes, declaration->args->isVariadic);
	if (type == NULL) {
		type = createTypeFunction(returnType, argumentTypes, declaration->args->isVariadic);
	};
	
	var symbol = Symbol_init();
	symbol->name = name->string;
	symbol->type = type;
	symbol->pos = name->pos;
	registerSymbol(symbol);
	
	if (declaration->block != NULL) {
		pushContext();
		var i = 0;
		while (i < Buffer_getCount((Void**)declaration->args->args)) {
			var argument = declaration->args->args[i];
			var symbol2 = Symbol_init();
			symbol2->name = argument->name->string;
			symbol2->type = argument->resolvedType;
			symbol2->pos = argument->name->pos;
			registerSymbol(symbol2);
			i = i + 1;
		};
		resolveStatementBlock(declaration->block, returnType);
		warnUnusedVariables();
		popContext();
	};
	
	return symbol;
};

func resolveDeclarationStruct(declaration: DeclarationStruct*, name: Token*): Symbol* {
	var symbol = Symbol_init();
	symbol->type = createTypeIdentifier(name);
	symbol->name = name->string;
	symbol->pos = name->pos;
	symbol->isType = true;
	registerSymbol(symbol);
	
	pushContext();
	symbol->children = contexts->context;
	
	var selfSymbol = Symbol_init();
	selfSymbol->name = String_init_literal("self");
	selfSymbol->type = resolveTypePointer(symbol->type);
	selfSymbol->pos = symbol->pos;
	selfSymbol->use();
	registerSymbol(selfSymbol);
	
	if (declaration->fields != NULL) {
		var i = 0;
		while (i < Buffer_getCount((Void**)declaration->fields)) {
			resolveDeclaration(declaration->fields[i]);
			i = i + 1;
		};
	};
	if (declaration->functions != NULL) {
		var i = 0;
		while (i < Buffer_getCount((Void**)declaration->functions)) {
			var funcSymbol = resolveDeclaration(declaration->functions[i]);
			funcSymbol->parent = symbol;
			i = i + 1;
		};
	};
	popContext();
	
	return symbol;
};

func resolveDeclarationEnumCase(enumCase: DeclarationEnumCase*, type: Type*) {
	var symbol = Symbol_init();
	symbol->type = type;
	symbol->name = enumCase->name->string;
	symbol->pos = enumCase->name->pos;
	registerSymbol(symbol);
};

func resolveDeclarationEnum(declaration: DeclarationEnum*, name: Token*): Symbol* {
	var symbol = Symbol_init();
	symbol->type = createTypeIdentifier(name);
	symbol->name = name->string;
	symbol->pos = name->pos;
	symbol->isType = true;
	
	pushContextChain();
	pushContext();
	var i = 0;
	while (i < Buffer_getCount((Void**)declaration->cases)) {
		resolveDeclarationEnumCase(declaration->cases[i], symbol->type);
		i = i + 1;
	};
	symbol->children = contexts->context;
	popContext();
	popContextChain();
	
	registerSymbol(symbol);
	return symbol;
};

func resolveDeclaration(declaration: Declaration*): Symbol* {
	if (declaration->state == .Resolved) { return declaration->symbol; }
	else if (declaration->state == .Unresolved) {}
	else if (declaration->state == .Resolving) {
		ResolverError(declaration->pos, "cyclic dependency for '", declaration->name->string->string, "'");
	} else if (declaration->state == .Invalid) {
		ProgrammingError("called resolveDeclaration on a .Invalid state");
	} else {
		ProgrammingError("called resolveDeclaration on a .Invalid state");
	};;;;
	
	declaration->state = .Resolving;
	if (declaration->kind == .Var) {
		declaration->symbol = resolveDeclarationVar((DeclarationVar*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Func) {
		declaration->symbol = resolveDeclarationFunc((DeclarationFunc*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Struct) {
		declaration->symbol = resolveDeclarationStruct((DeclarationStruct*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Enum) {
		declaration->symbol = resolveDeclarationEnum((DeclarationEnum*)declaration->declaration, declaration->name);
	} else {
		ProgrammingError("called resolveDeclaration on a .Invalid");
	};;;;
	declaration->state = .Resolved;
	return declaration->symbol;
};
