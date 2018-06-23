func resolveDeclarationVar(declaration: DeclarationVar*, name: Identifier*): Type* {
	var type: Type*;
	if (declaration->type != NULL) {
		type = resolveTypespec(declaration->type);
	};
	if (declaration->value != NULL) {
		var expressionType = resolveExpression(declaration->value, type);
		if (type == NULL) { type = expressionType; };
	};
	addTo(_context, name, type);
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

func resolveDeclarationTypeFunc(declaration: DeclarationFunc*, name: Identifier*): Type* {
	var argumentTypes = resolveDeclarationFuncArgs(declaration->args);
	var returnType = TypeVoid;
	if (declaration->returnType != NULL) {
		returnType = resolveTypespec(declaration->returnType);
	};
	var type = resolveTypeFunction(returnType, argumentTypes, declaration->args->isVariadic);
	if (type == NULL) {
		type = createTypeFunction(returnType, argumentTypes, declaration->args->isVariadic);
	};
	addTo(_context, name, type);
	return type;
};

func resolveDeclarationStruct(declaration: DeclarationStruct*, name: Identifier*): Type* {
	return createTypeIdentifier(name);
};

func resolveDeclarationEnum(declaration: DeclarationEnum*, name: Identifier*): Type* {
	return createTypeIdentifier(name);
};

func resolveDeclarationDefinitionStruct(declaration: DeclarationStruct*, name: Identifier*) {
	var before = Buffer_getCount((Void**)_context->names);
	if (declaration->fields != NULL) {
		var i = 0;
		while (i < Buffer_getCount((Void**)declaration->fields)) {
			resolveDeclarationDefinition(declaration->fields[i]);
			i = i + 1;
		};
	};
	Buffer_setCount((Void**)_context->names, before);
	Buffer_setCount((Void**)_context->types, before);
};

func resolveDeclarationType(declaration: Declaration*) {
	if (declaration->kind == .Var) {
	} else if (declaration->kind == .Func) {
	} else if (declaration->kind == .Struct) {
		declaration->resolvedType = resolveDeclarationStruct((DeclarationStruct*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Enum) {
		declaration->resolvedType = resolveDeclarationEnum((DeclarationEnum*)declaration->declaration, declaration->name);
	} else {
		ProgrammingError("called resolveDeclarationType on a .Invalid");
	};;;;
};

func resolveDeclarationDefinition(declaration: Declaration*) {
	if (declaration->state == .Resolved) { return; }
	else if (declaration->state == .Unresolved) {}
	else if (declaration->state == .Resolving) {
		ResolverError(declaration->pos, "cyclic dependency for '", declaration->name->name, "'");
	} else {
		ProgrammingError("called resolveDeclarationDefinition on a .Invalid state");
	};;;
	
	declaration->state = .Resolving;
	if (declaration->kind == .Var) {
		declaration->resolvedType = resolveDeclarationVar((DeclarationVar*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Func) {
		declaration->resolvedType = resolveDeclarationTypeFunc((DeclarationFunc*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Struct) {
		resolveDeclarationDefinitionStruct((DeclarationStruct*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Enum) {
	} else {
		ProgrammingError("called resolveDeclarationDefinition on a .Invalid");
	};;;;
	declaration->state = .Resolved;
};

func resolveDeclarationImplementationFunc(declaration: DeclarationFunc*, name: Identifier*): Type* {
	var argumentTypes = resolveDeclarationFuncArgs(declaration->args);
	var returnType = TypeVoid;
	if (declaration->returnType != NULL) {
		returnType = resolveTypespec(declaration->returnType);
	};
	if (declaration->block != NULL) {
		var oldContextCount = Buffer_getCount((Void**)_context->names);
		var i = 0;
		while (i < Buffer_getCount((Void**)declaration->args->args)) {
			var argument = declaration->args->args[i];
			addTo(_context, argument->name, argument->resolvedType);
			i = i + 1;
		};
		resolveStatementBlock(declaration->block, returnType);
		Buffer_setCount((Void**)_context->names, oldContextCount);
		Buffer_setCount((Void**)_context->types, oldContextCount);
	};
	var type = resolveTypeFunction(returnType, argumentTypes, declaration->args->isVariadic);
	if (type == NULL) {
		type = createTypeFunction(returnType, argumentTypes, declaration->args->isVariadic);
	};
	return type;
};

func resolveDeclarationImplementation(declaration: Declaration*) {
	if (declaration->state != .Resolved) {
		ProgrammingError("Declaration not resolved before resolving implementation");
	};
	if (declaration->kind == .Var) {
	} else if (declaration->kind == .Func) {
		declaration->resolvedType = resolveDeclarationImplementationFunc((DeclarationFunc*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Struct) {
	} else if (declaration->kind == .Enum) {
	} else {
		ProgrammingError("called resolveDeclarationImplementation on a .Invalid");
	};;;;
};
