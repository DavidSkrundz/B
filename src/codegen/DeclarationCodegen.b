func codegenDeclarationStructDeclaration(declaration: Declaration*) {
	printf((char*)"typedef struct ");
	codegenIdentifier(declaration->name->string);
	printf((char*)" ");
	codegenIdentifier(declaration->name->string);
	printf((char*)";\n");
};

func codegenDeclarationEnumDeclaration(declaration: Declaration*, decl: DeclarationEnum*) {
	codegenLine(declaration->pos);
	printf((char*)"typedef enum ");
	codegenIdentifier(declaration->name->string);
	printf((char*)" {\n");
	codegenDeclarationEnumCasesDefinition(decl->cases, declaration->name->string);
	printf((char*)"} ");
	codegenIdentifier(declaration->name->string);
	printf((char*)";\n");
};

func codegenDeclarationDeclaration(declaration: Declaration*) {
	if (declaration->attribute != NULL) { return; };
	
	if (declaration->kind == .Var) {
	} else if (declaration->kind == .Func) {
	} else if (declaration->kind == .Struct) {
		codegenDeclarationStructDeclaration(declaration);
	} else if (declaration->kind == .Enum) {
		codegenDeclarationEnumDeclaration(declaration, (DeclarationEnum*)declaration->declaration);
	} else {
		ProgrammingError("called codegenDeclarationDeclaration on a .Invalid");
	};;;;
};

func CodegenDeclarationDeclarations() {
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		codegenDeclarationDeclaration(_declarations[i]);
		i = i + 1;
	};
	printf((char*)"\n");
};

func codegenDeclarationVarDefinition(declaration: Declaration*, decl: DeclarationVar*) {
	codegenLine(declaration->pos);
	codegenType(declaration->resolvedType);
	printf((char*)" ");
	codegenIdentifier(declaration->name->string);
	printf((char*)" = ");
	if (decl->value == NULL) {
		codegenNullExpression(declaration->resolvedType);
	} else {
		codegenExpression(decl->value);
	};
	printf((char*)";\n");
};

func codegenDeclarationFuncArg(argument: DeclarationFuncArg*) {
	codegenType(argument->resolvedType);
	printf((char*)" ");
	codegenIdentifier(argument->name->string);
};

func codegenDeclarationFuncArgs(args: DeclarationFuncArgs*) {
	printf((char*)"(");
	if (Buffer_getCount((Void**)args->args) == 0) {
		printf((char*)"void");
	};
	var i = 0;
	while (i < Buffer_getCount((Void**)args->args)) {
		codegenDeclarationFuncArg(args->args[i]);
		i = i + 1;
		if (i < Buffer_getCount((Void**)args->args)) { printf((char*)", "); };
	};
	printf((char*)")");
};

func codegenDeclarationFuncDefinition(declaration: Declaration*, decl: DeclarationFunc*) {
	if (declaration->resolvedType->kind != .Function) {
		ProgrammingError("called codegenDeclarationFuncDefinition non-.Function");
	};
	var funcType = (TypeFunction*)declaration->resolvedType->type;
	codegenType(funcType->returnType);
	printf((char*)" ");
	codegenIdentifier(declaration->name->string);
	codegenDeclarationFuncArgs(decl->args);
	printf((char*)";\n");
};

func codegenDeclarationStructFieldDefinition(field: Declaration*) {
	if (field->kind != .Var) {
		ProgrammingError("called codegenDeclarationStructFieldDefinition with non-.Var");
	};
	printf((char*)"\t");
	codegenType(field->resolvedType);
	printf((char*)" ");
	codegenIdentifier(field->name->string);
	printf((char*)";\n");
};

func codegenDeclarationStructDefinition(declaration: Declaration*, decl: DeclarationStruct*) {
	codegenLine(declaration->pos);
	printf((char*)"struct ");
	codegenIdentifier(declaration->name->string);
	printf((char*)" {\n");
	var i = 0;
	while (i < Buffer_getCount((Void**)decl->fields)) {
		codegenDeclarationStructFieldDefinition(decl->fields[i]);
		i = i + 1;
	};
	printf((char*)"};\n");
};

func codegenDeclarationEnumCasesDefinition(cases: DeclarationEnumCase**, name: String*) {
	var i = 0;
	while (i < Buffer_getCount((Void**)cases)) {
		printf((char*)"\t");
		codegenIdentifier(name);
		printf((char*)"_");
		codegenIdentifier(cases[i]->name->string);
		printf((char*)",\n");
		i = i + 1;
	};
};

func codegenDeclarationDefinition(declaration: Declaration*) {
	if (declaration->attribute != NULL) { return; };
	
	if (declaration->kind == .Var) {
		codegenDeclarationVarDefinition(declaration, (DeclarationVar*)declaration->declaration);
	} else if (declaration->kind == .Func) {
		codegenDeclarationFuncDefinition(declaration, (DeclarationFunc*)declaration->declaration);
	} else if (declaration->kind == .Struct) {
		codegenDeclarationStructDefinition(declaration, (DeclarationStruct*)declaration->declaration);
	} else if (declaration->kind == .Enum) {
	} else {
		ProgrammingError("called codegenDeclarationDefinition on a .Invalid");
	};;;;
};

func CodegenDeclarationDefinitions() {
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		codegenDeclarationDefinition(_declarations[i]);
		i = i + 1;
	};
	printf((char*)"\n");
};

func codegenDeclarationFuncImplementation(declaration: Declaration*, decl: DeclarationFunc*) {
	if (declaration->resolvedType->kind != .Function) {
		ProgrammingError("called codegenDeclarationFuncImplementation non-.Function");
	};
	codegenLine(declaration->pos);
	var funcType = (TypeFunction*)declaration->resolvedType->type;
	codegenType(funcType->returnType);
	printf((char*)" ");
	codegenIdentifier(declaration->name->string);
	codegenDeclarationFuncArgs(decl->args);
	printf((char*)" ");
	codegenStatementBlock(decl->block);
	printf((char*)"\n\n");
};

func codegenDeclarationImplementation(declaration: Declaration*) {
	if (declaration->attribute != NULL) { return; };
	
	if (declaration->kind == .Var) {
	} else if (declaration->kind == .Func) {
		codegenDeclarationFuncImplementation(declaration, (DeclarationFunc*)declaration->declaration);
	} else if (declaration->kind == .Struct) {
	} else if (declaration->kind == .Enum) {
	} else {
		ProgrammingError("called codegenDeclarationImplementation on a .Invalid");
	};;;;
};

func CodegenDeclarationImplementations() {
	var i = 0;
	while (i < Buffer_getCount((Void**)_declarations)) {
		codegenDeclarationImplementation(_declarations[i]);
		i = i + 1;
	};
};
