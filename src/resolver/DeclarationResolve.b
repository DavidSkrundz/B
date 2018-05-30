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
	var argumentTypes = (Type**)xcalloc(MAX_FUNC_ARGUMENT_COUNT, sizeof(Type*));
	var i = 0;
	while (i < args->count) {
		argumentTypes[i] = resolveDeclarationFuncArg(args->args[i]);
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
	var type = resolveTypeFunction(returnType, argumentTypes, declaration->args->count, declaration->args->isVariadic);
	if (type == NULL) {
		type = createTypeFunction(returnType, argumentTypes, declaration->args->count, declaration->args->isVariadic);
	};
	addTo(_context, name, type);
	return type;
};

func resolveDeclarationStructFields(fields: DeclarationStructFields*) {
	var i = 0;
	while (i < fields->count) {
		resolveDeclarationDefinition(fields->fields[i]);
		i = i + 1;
	};
};

func resolveDeclarationStruct(declaration: DeclarationStruct*, name: Identifier*): Type* {
	return createTypeIdentifier(name);
};

func resolveDeclarationDefinitionStruct(declaration: DeclarationStruct*, name: Identifier*) {
	var before = bufferCount((Void**)_context->names);
	if (declaration->fields != NULL) {
		resolveDeclarationStructFields(declaration->fields);
	};
	setBufferCount((Void**)_context->names, before);
	setBufferCount((Void**)_context->types, before);
};

func resolveDeclarationType(declaration: Declaration*) {
	if (declaration->kind == DeclarationKind_Var) {
	} else if (declaration->kind == DeclarationKind_Func) {
	} else if (declaration->kind == DeclarationKind_Struct) {
		declaration->resolvedType = resolveDeclarationStruct((DeclarationStruct*)declaration->declaration, declaration->name);
	} else {
		fprintf(stderr, (char*)"Invalid declaration kind %zu%c", declaration->kind, 10);
		abort();
	};;;
};

func resolveDeclarationDefinition(declaration: Declaration*) {
	if (declaration->state == DeclarationState_Resolved) { return; }
	else if (declaration->state == DeclarationState_Unresolved) {}
	else if (declaration->state == DeclarationState_Resolving) {
		fprintf(stderr, (char*)"Cyclic dependency%c", 10);
		exit(EXIT_FAILURE);
	} else {
		fprintf(stderr, (char*)"Invalid declaration state %zu%c", declaration->state, 10);
		abort();
	};;;
	
	declaration->state = DeclarationState_Resolving;
	if (declaration->kind == DeclarationKind_Var) {
		declaration->resolvedType = resolveDeclarationVar((DeclarationVar*)declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Func) {
		declaration->resolvedType = resolveDeclarationTypeFunc((DeclarationFunc*)declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Struct) {
		resolveDeclarationDefinitionStruct((DeclarationStruct*)declaration->declaration, declaration->name);
	} else {
		fprintf(stderr, (char*)"Invalid declaration kind %zu%c", declaration->kind, 10);
		abort();
	};;;
	declaration->state = DeclarationState_Resolved;
};

func resolveDeclarationImplementationFunc(declaration: DeclarationFunc*, name: Identifier*): Type* {
	var argumentTypes = resolveDeclarationFuncArgs(declaration->args);
	var returnType = TypeVoid;
	if (declaration->returnType != NULL) {
		returnType = resolveTypespec(declaration->returnType);
	};
	if (declaration->block != NULL) {
		var oldContextCount = bufferCount((Void**)_context->names);
		var i = 0;
		while (i < declaration->args->count) {
			var argument = declaration->args->args[i];
			addTo(_context, argument->name, argument->resolvedType);
			i = i + 1;
		};
		resolveStatementBlock(declaration->block, returnType);
		setBufferCount((Void**)_context->names, oldContextCount);
		setBufferCount((Void**)_context->types, oldContextCount);
	};
	var type = resolveTypeFunction(returnType, argumentTypes, declaration->args->count, declaration->args->isVariadic);
	if (type == NULL) {
		type = createTypeFunction(returnType, argumentTypes, declaration->args->count, declaration->args->isVariadic);
	};
	return type;
};

func resolveDeclarationImplementation(declaration: Declaration*) {
	if (declaration->state != DeclarationState_Resolved) {
		fprintf(stderr, (char*)"Declaration not resolved before resolving implementation");
		abort();
	};
	if (declaration->kind == DeclarationKind_Var) {
	} else if (declaration->kind == DeclarationKind_Func) {
		declaration->resolvedType = resolveDeclarationImplementationFunc((DeclarationFunc*)declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Struct) {
	} else {
		fprintf(stderr, (char*)"Invalid declaration kind %zu%c", declaration->kind, 10);
		abort();
	};;;
};
