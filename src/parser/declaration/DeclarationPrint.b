func printDeclarationVar(declaration: DeclarationVar*, name: Identifier*) {
	printf((char*)"(var ");
	printIdentifier(name);
	if (declaration->type != NULL) {
		printf((char*)" ");
		printTypespec(declaration->type);
	};
	if (declaration->value != NULL) {
		printf((char*)" (expression\n");
		depth = depth + 1;
		depth = depth + 1;
		printDepth();
		printExpression(declaration->value);
		depth = depth - 1;
		depth = depth - 1;
		printf((char*)"\n");
		printDepth();
		printf((char*)")");
	};
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
	printf((char*)"(arguments\n");
	depth = depth + 1;
	var i = 0;
	while (i < Buffer_getCount((Void**)args->args)) {
		printDepth();
		printDeclarationFuncArg(args->args[i]);
		printf((char*)"\n");
		i = i + 1;
	};
	if (args->isVariadic) {
		printDepth();
		printf((char*)"(...)\n");
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
	printf((char*)"\n");
	depth = depth + 1;
	printDepth();
	printDeclarationFuncArgs(declaration->args);
	printf((char*)"\n");
	if (declaration->block != NULL) {
		printDepth();
		printStatementBlock(declaration->block);
		printf((char*)"\n");
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printDeclarationStruct(declaration: DeclarationStruct*, name: Identifier*) {
	printf((char*)"(struct\n");
	depth = depth + 1;
	printDepth();
	printIdentifier(name);
	printf((char*)"\n");
	if (declaration->fields != NULL) {
		printDepth();
		printf((char*)"(fields\n");
		depth = depth + 1;
		var i = 0;
		while (i < Buffer_getCount((Void**)declaration->fields)) {
			printDepth();
			printDeclaration(declaration->fields[i]);
			printf((char*)"\n");
			i = i + 1;
		};
		depth = depth - 1;
		printDepth();
		printf((char*)")");
		printf((char*)"\n");
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
	printf((char*)"(enum\n");
	depth = depth + 1;
	printDepth();
	printIdentifier(name);
	printf((char*)"\n");
	var i = 0;
	while (i < Buffer_getCount((Void**)declaration->cases)) {
		printDepth();
		printDeclarationEnumCase((declaration->cases)[i]);
		printf((char*)"\n");
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
	
	if (declaration->kind == .Var) {
		printDeclarationVar((DeclarationVar*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Func) {
		printDeclarationFunc((DeclarationFunc*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Struct) {
		printDeclarationStruct((DeclarationStruct*)declaration->declaration, declaration->name);
	} else if (declaration->kind == .Enum) {
		printDeclarationEnum((DeclarationEnum*)declaration->declaration, declaration->name);
	} else {
		fprintf(stderr, (char*)"Invalid declaration kind %u\n", declaration->kind);
		abort();
	};;;;
};

func printDeclarations() {
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		printDeclaration(_declarations[i]);
		printf((char*)"\n\n");
		i = i + 1;
	};
};
