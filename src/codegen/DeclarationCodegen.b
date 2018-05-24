func codegenDeclarationStructDeclaration(declaration: Declaration*, decl: DeclarationStruct*) {
	printf((char*)"typedef struct ");
	codegenIdentifier(declaration->name);
	printf((char*)" ");
	codegenIdentifier(declaration->name);
	printf((char*)";%c", 10);
};

func codegenDeclarationDeclaration(declaration: Declaration*) {
	if (declaration->attribute != NULL) { return; };
	
	if (declaration->kind == DeclarationKind_Var) {
	} else if (declaration->kind == DeclarationKind_Func) {
	} else if (declaration->kind == DeclarationKind_Struct) {
		codegenDeclarationStructDeclaration(declaration, (DeclarationStruct*)declaration->declaration);
	} else {
		fprintf(stderr, (char*)"Invalid declaration kind %zu%c", declaration->kind, 10);
		abort();
	};;;
};

func CodegenDeclarationDeclarations() {
	var i = (UInt)0;
	while (i < _declarationCount) {
		codegenDeclarationDeclaration(_declarations[i]);
		i = i + (UInt)1;
	};
	printf((char*)"%c", 10);
};

func codegenDeclarationVarDefinition(declaration: Declaration*, decl: DeclarationVar*) {
	codegenType(declaration->resolvedType);
	printf((char*)" ");
	codegenIdentifier(declaration->name);
	printf((char*)" = ");
	if (decl->value == NULL) {
		codegenNullExpression(declaration->resolvedType);
	} else {
		codegenExpression(decl->value);
	};
	printf((char*)";%c", 10);
};

func codegenDeclarationFuncArg(argument: DeclarationFuncArg*) {
	codegenType(argument->resolvedType);
	printf((char*)" ");
	codegenIdentifier(argument->name);
};

func codegenDeclarationFuncArgs(args: DeclarationFuncArgs*) {
	printf((char*)"(");
	if (args->count == (UInt)0) {
		printf((char*)"void");
	};
	var i = (UInt)0;
	while (i < args->count) {
		codegenDeclarationFuncArg(args->args[i]);
		i = i + (UInt)1;
		if (i < args->count) { printf((char*)", "); };
	};
	printf((char*)")");
};

func codegenDeclarationFuncDefinition(declaration: Declaration*, decl: DeclarationFunc*) {
	if (declaration->resolvedType->kind != TypeKind_Function) {
		fprintf(stderr, (char*)"Function declaration has non function type%c", 10);
		abort();
	};
	var funcType = (TypeFunction*)declaration->resolvedType->type;
	codegenType(funcType->returnType);
	printf((char*)" ");
	codegenIdentifier(declaration->name);
	codegenDeclarationFuncArgs(decl->args);
	printf((char*)";%c", 10);
};

func codegenDeclarationStructFieldDefinition(field: Declaration*) {
	if (field->kind != DeclarationKind_Var) {
		fprintf(stderr, (char*)"Bad declaration kind (%zu) in struct fields%c", field->kind, 10);
		abort();
	};
	printf((char*)"%c", 9);
	codegenType(field->resolvedType);
	printf((char*)" ");
	codegenIdentifier(field->name);
	printf((char*)";%c", 10);
};

func codegenDeclarationStructFieldsDefinition(fields: DeclarationStructFields*) {
	var i = (UInt)0;
	while (i < fields->count) {
		codegenDeclarationStructFieldDefinition(fields->fields[i]);
		i = i + (UInt)1;
	};
};

func codegenDeclarationStructDefinition(declaration: Declaration*, decl: DeclarationStruct*) {
	printf((char*)"struct ");
	codegenIdentifier(declaration->name);
	printf((char*)" {%c", 10);
	codegenDeclarationStructFieldsDefinition(decl->fields);
	printf((char*)"};%c", 10);
};

func codegenDeclarationDefinition(declaration: Declaration*) {
	if (declaration->attribute != NULL) { return; };
	
	if (declaration->kind == DeclarationKind_Var) {
		codegenDeclarationVarDefinition(declaration, (DeclarationVar*)declaration->declaration);
	} else if (declaration->kind == DeclarationKind_Func) {
		codegenDeclarationFuncDefinition(declaration, (DeclarationFunc*)declaration->declaration);
	} else if (declaration->kind == DeclarationKind_Struct) {
		codegenDeclarationStructDefinition(declaration, (DeclarationStruct*)declaration->declaration);
	} else {
		fprintf(stderr, (char*)"Invalid declaration kind %zu%c", declaration->kind, 10);
		abort();
	};;;
};

func CodegenDeclarationDefinitions() {
	var i = (UInt)0;
	while (i < _declarationCount) {
		codegenDeclarationDefinition(_declarations[i]);
		i = i + (UInt)1;
	};
	printf((char*)"%c", 10);
};

func codegenDeclarationFuncImplementation(declaration: Declaration*, decl: DeclarationFunc*) {
	if (declaration->resolvedType->kind != TypeKind_Function) {
		fprintf(stderr, (char*)"Function declaration has non function type%c", 10);
		abort();
	};
	var funcType = (TypeFunction*)declaration->resolvedType->type;
	codegenType(funcType->returnType);
	printf((char*)" ");
	codegenIdentifier(declaration->name);
	codegenDeclarationFuncArgs(decl->args);
	printf((char*)" ");
	codegenStatementBlock(decl->block);
	printf((char*)"%c%c", 10, 10);
};

func codegenDeclarationImplementation(declaration: Declaration*) {
	if (declaration->attribute != NULL) { return; };
	
	if (declaration->kind == DeclarationKind_Var) {
	} else if (declaration->kind == DeclarationKind_Func) {
		codegenDeclarationFuncImplementation(declaration, (DeclarationFunc*)declaration->declaration);
	} else if (declaration->kind == DeclarationKind_Struct) {
	} else {
		fprintf(stderr, (char*)"Invalid declaration kind %zu%c", declaration->kind, 10);
		abort();
	};;;
};

func CodegenDeclarationImplementations() {
	var i = (UInt)0;
	while (i < _declarationCount) {
		codegenDeclarationImplementation(_declarations[i]);
		i = i + (UInt)1;
	};
};
