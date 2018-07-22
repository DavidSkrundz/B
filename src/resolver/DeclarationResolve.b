func resolveDeclarationVar(declaration: DeclarationVar*, name: Token*, isGlobal: Bool): Type* {
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
	if (isGlobal) {
		registerGlobalSymbol(symbol);
	} else {
		registerSymbol(symbol);
	};
	return type;
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

func resolveDeclarationFunc(declaration: DeclarationFunc*, name: Token*): Type* {
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
	registerGlobalSymbol(symbol);
	
	if (declaration->block != NULL) {
		pushContext();
		var i = 0;
		while (i < Buffer_getCount((Void**)declaration->args->args)) {
			var argument = declaration->args->args[i];
			symbol = Symbol_init();
			symbol->name = argument->name->string;
			symbol->type = argument->resolvedType;
			symbol->pos = argument->name->pos;
			registerSymbol(symbol);
			i = i + 1;
		};
		resolveStatementBlock(declaration->block, returnType);
		warnUnusedVariables();
		popContext();
	};
	
	return type;
};

func resolveDeclarationStruct(declaration: DeclarationStruct*, name: Token*): Type* {
	var type = createTypeIdentifier(name);
	pushContext();
	if (declaration->fields != NULL) {
		var i = 0;
		while (i < Buffer_getCount((Void**)declaration->fields)) {
			resolveDeclaration(declaration->fields[i], false);
			i = i + 1;
		};
	};
	popContext();
	return type;
};

func resolveDeclarationEnum(name: Token*): Type* {
	var type = createTypeIdentifier(name);
	return type;
};

func resolveDeclaration(declaration: Declaration*, isGlobal: Bool) {
	if (declaration->state == .Resolved) { return; }
	else if (declaration->state == .Unresolved) {}
	else if (declaration->state == .Resolving) {
		ResolverError(declaration->pos, "cyclic dependency for '", declaration->name->string->string, "'");
	} else {
		ProgrammingError("called resolveDeclaration on a .Invalid state");
	};;;
	
	var stash: Context*;
	if (isGlobal) { stash = stashContext(); };
	
	declaration->state = .Resolving;
	if (declaration->kind == .Var) {
		declaration->resolvedType = resolveDeclarationVar((DeclarationVar*)declaration->declaration, declaration->name, isGlobal);
	} else if (declaration->kind == .Func) {
		declaration->resolvedType = resolveDeclarationFunc((DeclarationFunc*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Struct) {
		declaration->resolvedType = resolveDeclarationStruct((DeclarationStruct*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Enum) {
		declaration->resolvedType = resolveDeclarationEnum(declaration->name);
	} else {
		ProgrammingError("called resolveDeclaration on a .Invalid");
	};;;;
	declaration->state = .Resolved;
	
	if (isGlobal) { restoreContext(stash); };
};
