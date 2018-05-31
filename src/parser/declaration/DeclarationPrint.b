func printDeclarationVar(declaration: DeclarationVar*, name: Identifier*) {
	printf((char*)"(var ");
	printIdentifier(name);
	if (declaration->type != NULL) {
		printf((char*)" ");
		printTypespec(declaration->type);
	};
	if (declaration->value != NULL) {
		printf((char*)" (expression%c", 10);
		depth = depth + 1;
		depth = depth + 1;
		printDepth();
		printExpression(declaration->value);
		depth = depth - 1;
		depth = depth - 1;
		printf((char*)"%c", 10);
		printDepth();
		printf((char*)")");
	};
	printf((char*)")");
};

func printDeclarationStructFields(fields: DeclarationStructFields*) {
	printf((char*)"(fields%c", 10);
	depth = depth + 1;
	var i = 0;
	while (i < fields->count) {
		printDepth();
		printDeclaration(fields->fields[i]);
		printf((char*)"%c", 10);
		i = i + 1;
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printDeclarationFuncArg(arg: DeclarationFuncArg*) {
	printf((char*)"(");
	printIdentifier(arg->name);
	printf((char*)" ");
	printTypespec(arg->type);
	printf((char*)")");
};

func printDeclarationFuncArgs(args: DeclarationFuncArgs*) {
	printf((char*)"(arguments%c", 10);
	depth = depth + 1;
	var i = 0;
	while (i < args->count) {
		printDepth();
		printDeclarationFuncArg(args->args[i]);
		printf((char*)"%c", 10);
		i = i + 1;
	};
	if (args->isVariadic) {
		printDepth();
		printf((char*)"(...)%c", 10);
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printDeclarationFunc(declaration: DeclarationFunc*, name: Identifier*) {
	printf((char*)"(func ");
	printIdentifier(name);
	printf((char*)" ");
	if (declaration->returnType == NULL) {
		printf((char*)"()");
	} else {
		printTypespec(declaration->returnType);
	};
	printf((char*)"%c", 10);
	depth = depth + 1;
	printDepth();
	printDeclarationFuncArgs(declaration->args);
	printf((char*)"%c", 10);
	if (declaration->block != NULL) {
		printDepth();
		printStatementBlock(declaration->block);
		printf((char*)"%c", 10);
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printDeclarationStruct(declaration: DeclarationStruct*, name: Identifier*) {
	printf((char*)"(struct%c", 10);
	depth = depth + 1;
	printDepth();
	printIdentifier(name);
	printf((char*)"%c", 10);
	if (declaration->fields != NULL) {
		printDepth();
		printDeclarationStructFields(declaration->fields);
		printf((char*)"%c", 10);
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printDeclarationEnumCase(enumCase: DeclarationEnumCase*) {
	printf((char*)"(case ");
	printIdentifier(enumCase->name);
	printf((char*)")");
};

func printDeclarationEnum(declaration: DeclarationEnum*, name: Identifier*) {
	printf((char*)"(enum%c", 10);
	depth = depth + 1;
	printDepth();
	printIdentifier(name);
	printf((char*)"%c", 10);
	var i = 0;
	while (i < bufferCount((Void**)declaration->cases)) {
		printDepth();
		printDeclarationEnumCase((declaration->cases)[i]);
		printf((char*)"%c", 10);
		i = i + 1;
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printDeclaration(declaration: Declaration*) {
	if (declaration->attribute != NULL) {
		printAttribute(declaration->attribute);
	};
	
	if (declaration->kind == DeclarationKind_Var) {
		printDeclarationVar((DeclarationVar*)declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Func) {
		printDeclarationFunc((DeclarationFunc*)declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Struct) {
		printDeclarationStruct((DeclarationStruct*)declaration->declaration, declaration->name);
	} else if (declaration->kind == DeclarationKind_Enum) {
		printDeclarationEnum((DeclarationEnum*)declaration->declaration, declaration->name);
	} else {
		fprintf(stderr, (char*)"Invalid declaration kind %zu%c", declaration->kind, 10);
		abort();
	};;;;
};

func printDeclarations() {
	var i = 0;
	while (i < bufferCount((Void**)_declarations)) {
		printDeclaration(_declarations[i]);
		printf((char*)"%c%c", 10, 10);
		i = i + 1;
	};
};
