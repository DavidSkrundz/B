func parseDeclarationVar(tokens: Token***, declaration: Declaration*): DeclarationVar* {
	expectToken(.Var);
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; };
	var decl = newDeclarationVar();
	if (checkToken(.Colon)) {
		decl->type = parseTypespec(tokens);
	};
	if (checkToken(.Assign)) {
		decl->value = parseExpression(tokens);
	};
	expectToken(.Semicolon);
	if (decl->type == NULL && decl->value == NULL) { return NULL; };
	return decl;
};

var MAX_STRUCT_FIELD_COUNT = 100;
func parseDeclarationStructFields(tokens: Token***): DeclarationStructFields* {
	expectToken(.OpenCurly);
	var fields = newDeclarationStructFields();
	fields->fields = (Declaration**)xcalloc(MAX_STRUCT_FIELD_COUNT, sizeof(Declaration*));
	fields->count = 0;
	while ((**tokens)->kind != .CloseCurly) {
		if (fields->count == MAX_STRUCT_FIELD_COUNT) {
			fprintf(stderr, (char*)"Too many fields in struct%c", 10);
			exit(EXIT_FAILURE);
		};
		var varDecl = parseDeclaration(tokens);
		if (varDecl == NULL) { return NULL; };
		if (varDecl->kind != DeclarationKind_Var) { return NULL; };
		fields->fields[fields->count] = varDecl;
		fields->count = fields->count + 1;
	};
	expectToken(.CloseCurly);
	return fields;
};

func parseDeclarationFuncArgument(tokens: Token***): DeclarationFuncArg* {
	var arg = newDeclarationFuncArg();
	arg->name = parseIdentifier(tokens);
	if (arg->name == NULL) { return NULL; };
	expectToken(.Colon);
	arg->type = parseTypespec(tokens);
	if (arg->type == NULL) { return NULL; };
	return arg;
};

var MAX_FUNC_ARGUMENT_COUNT = 10;
func parseDeclarationFuncArguments(tokens: Token***): DeclarationFuncArgs* {
	expectToken(.OpenParenthesis);
	var args = newDeclarationFuncArgs();
	args->args = (DeclarationFuncArg**)xcalloc(MAX_FUNC_ARGUMENT_COUNT, sizeof(DeclarationFuncArg*));
	args->count = 0;
	if (args->count == MAX_FUNC_ARGUMENT_COUNT) {
		fprintf(stderr, (char*)"Too many arguments in func%c", 10);
		exit(EXIT_FAILURE);
	};
	var arg = parseDeclarationFuncArgument(tokens);
	if (arg != NULL) {
		args->args[args->count] = arg;
		args->count = args->count + 1;
	};
	while (checkToken(.Comma)) {
		if (args->count == MAX_FUNC_ARGUMENT_COUNT) {
			fprintf(stderr, (char*)"Too many arguments in func%c", 10);
			exit(EXIT_FAILURE);
		};
		var arg2 = parseDeclarationFuncArgument(tokens);
		if (arg2 != NULL) {
			args->args[args->count] = arg2;
			args->count = args->count + 1;
		};
	};
	if (checkToken(.Ellipses)) {
		args->isVariadic = true;
	};
	expectToken(.CloseParenthesis);
	return args;
};

func parseDeclarationFunc(tokens: Token***, declaration: Declaration*): DeclarationFunc* {
	expectToken(.Func);
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; };
	var decl = newDeclarationFunc();
	decl->args = parseDeclarationFuncArguments(tokens);
	if (decl->args == NULL) { return NULL; };
	if (checkToken(.Colon)) {
		decl->returnType = parseTypespec(tokens);
		if (decl->returnType == NULL) { return NULL; };
	};
	if ((**tokens)->kind == .OpenCurly) {
		decl->block = parseStatementBlock(tokens);
		if (decl->block == NULL) { return NULL; };
	};
	expectToken(.Semicolon);
	return decl;
};

func parseDeclarationStruct(tokens: Token***, declaration: Declaration*): DeclarationStruct* {
	expectToken(.Struct);
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; };
	var decl = newDeclarationStruct();
	if ((**tokens)->kind == .OpenCurly) {
		decl->fields = parseDeclarationStructFields(tokens);
		if (decl->fields == NULL) { return NULL; };
	};
	expectToken(.Semicolon);
	return decl;
};

func parseDeclarationEnum(tokens: Token***, declaration: Declaration*): DeclarationEnum* {
	expectToken(.Enum);
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; };
	var decl = newDeclarationEnum();
	expectToken(.OpenCurly);
	while ((**tokens)->kind != .CloseCurly) {
		expectToken(.Case);
		var caseName = parseIdentifier(tokens);
		if (caseName == NULL) { return NULL; };
		expectToken(.Semicolon);
		var i = 0;
		while (i < bufferCount((Void**)decl->cases)) {
			if (caseName->length == decl->cases[i]->name->length) {
				if (strncmp((char*)decl->cases[i]->name->name, (char*)caseName->name, caseName->length) == (int)0) {
					fprintf(stderr, (char*)"Duplicate enum case %.*s%c", (int)caseName->length, caseName->name, 10);
					exit(EXIT_FAILURE);
				};
			};
			i = i + 1;
		};
		var enumCase = newDeclarationEnumCase();
		enumCase->name = caseName;
		append((Void***)&decl->cases, (Void*)enumCase);
	};
	expectToken(.CloseCurly);
	expectToken(.Semicolon);
	return decl;
};

func parseDeclaration(tokens: Token***): Declaration* {
	var declaration = newDeclaration();
	declaration->attribute = parseAttribute(tokens);
	declaration->state = DeclarationState_Unresolved;
	if ((**tokens)->kind == .Var) {
		declaration->kind = DeclarationKind_Var;
		declaration->declaration = (Void*)parseDeclarationVar(tokens, declaration);
	} else if ((**tokens)->kind == .Func) {
		declaration->kind = DeclarationKind_Func;
		declaration->declaration = (Void*)parseDeclarationFunc(tokens, declaration);
	} else if ((**tokens)->kind == .Struct) {
		declaration->kind = DeclarationKind_Struct;
		declaration->declaration = (Void*)parseDeclarationStruct(tokens, declaration);
	} else if ((**tokens)->kind == .Enum) {
		declaration->kind = DeclarationKind_Enum;
		declaration->declaration = (Void*)parseDeclarationEnum(tokens, declaration);
	};;;;
	if (declaration->declaration == NULL) { return NULL; };
	return declaration;
};
