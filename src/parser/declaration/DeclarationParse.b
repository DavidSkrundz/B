func parseDeclarationVar(tokens: Token***, declaration: Declaration*): DeclarationVar* {
	if ((**tokens)->kind != TokenKind_Var) { return NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; };
	var decl = newDeclarationVar();
	if ((**tokens)->kind == TokenKind_Colon) {
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		decl->type = parseTypespec(tokens);
	};
	if ((**tokens)->kind == TokenKind_Assign) {
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		decl->value = parseExpression(tokens);
	};
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	if (decl->type == NULL && decl->value == NULL) { return NULL; };
	return decl;
};

var MAX_STRUCT_FIELD_COUNT = (UInt)100;
func parseDeclarationStructFields(tokens: Token***): DeclarationStructFields* {
	if ((**tokens)->kind != TokenKind_OpenCurly) { return NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	var fields = newDeclarationStructFields();
	fields->fields = (Declaration**)xcalloc(MAX_STRUCT_FIELD_COUNT, sizeof(Declaration*));
	fields->count = (UInt)0;
	while ((**tokens)->kind != TokenKind_CloseCurly) {
		if (fields->count == MAX_STRUCT_FIELD_COUNT) {
			fprintf(stderr, (char*)"Too many fields in struct%c", 10);
			exit(EXIT_FAILURE);
		};
		var varDecl = parseDeclaration(tokens);
		if (varDecl == NULL) { return NULL; };
		if (varDecl->kind != DeclarationKind_Var) { return NULL; };
		fields->fields[fields->count] = varDecl;
		fields->count = fields->count + (UInt)1;
	};
	return fields;
};

func parseDeclarationFuncArgument(tokens: Token***): DeclarationFuncArg* {
	var arg = newDeclarationFuncArg();
	arg->name = parseIdentifier(tokens);
	if (arg->name == NULL) { return NULL; };
	if ((**tokens)->kind != TokenKind_Colon) { return NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	arg->type = parseTypespec(tokens);
	if (arg->type == NULL) { return NULL; };
	return arg;
};

var MAX_FUNC_ARGUMENT_COUNT = (UInt)10;
func parseDeclarationFuncArguments(tokens: Token***): DeclarationFuncArgs* {
	if ((**tokens)->kind != TokenKind_OpenParenthesis) { return NULL; };
	var args = newDeclarationFuncArgs();
	args->args = (DeclarationFuncArg**)xcalloc(MAX_FUNC_ARGUMENT_COUNT, sizeof(DeclarationFuncArg*));
	args->count = (UInt)0;
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	if (args->count == MAX_FUNC_ARGUMENT_COUNT) {
		fprintf(stderr, (char*)"Too many arguments in func%c", 10);
		exit(EXIT_FAILURE);
	};
	var arg = parseDeclarationFuncArgument(tokens);
	if (arg != NULL) {
		args->args[args->count] = arg;
		args->count = args->count + (UInt)1;
	};
	while ((**tokens)->kind == TokenKind_Comma) {
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		if (args->count == MAX_FUNC_ARGUMENT_COUNT) {
			fprintf(stderr, (char*)"Too many arguments in func%c", 10);
			exit(EXIT_FAILURE);
		};
		var arg2 = parseDeclarationFuncArgument(tokens);
		if (arg2 != NULL) {
			args->args[args->count] = arg2;
			args->count = args->count + (UInt)1;
		};
	};
	if ((**tokens)->kind == TokenKind_Ellipses) {
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		args->isVariadic = true;
	};
	if ((**tokens)->kind != TokenKind_CloseParenthesis) { return NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	return args;
};

func parseDeclarationFunc(tokens: Token***, declaration: Declaration*): DeclarationFunc* {
	if ((**tokens)->kind != TokenKind_Func) { return NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; };
	var decl = newDeclarationFunc();
	decl->args = parseDeclarationFuncArguments(tokens);
	if (decl->args == NULL) { return NULL; };
	if ((**tokens)->kind == TokenKind_Colon) {
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
		decl->returnType = parseTypespec(tokens);
		if (decl->returnType == NULL) { return NULL; };
	};
	if ((**tokens)->kind == TokenKind_OpenCurly) {
		decl->block = parseStatementBlock(tokens);
		if (decl->block == NULL) { return NULL; };
	};
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	return decl;
};

func parseDeclarationStruct(tokens: Token***, declaration: Declaration*): DeclarationStruct* {
	if ((**tokens)->kind != TokenKind_Struct) { return NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; };
	var decl = newDeclarationStruct();
	if ((**tokens)->kind == TokenKind_OpenCurly) {
		decl->fields = parseDeclarationStructFields(tokens);
		if (decl->fields == NULL) { return NULL; };
		if ((**tokens)->kind != TokenKind_CloseCurly) { return NULL; };
		*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	};
	if ((**tokens)->kind != TokenKind_Semicolon) { return NULL; };
	*tokens = (Token**)((UInt)*tokens + sizeof(Token*));
	return decl;
};

func parseDeclaration(tokens: Token***): Declaration* {
	var declaration = newDeclaration();
	declaration->attribute = parseAttribute(tokens);
	declaration->state = DeclarationState_Unresolved;
	if ((**tokens)->kind == TokenKind_Var) {
		declaration->kind = DeclarationKind_Var;
		declaration->declaration = (Void*)parseDeclarationVar(tokens, declaration);
	} else if ((**tokens)->kind == TokenKind_Func) {
		declaration->kind = DeclarationKind_Func;
		declaration->declaration = (Void*)parseDeclarationFunc(tokens, declaration);
	} else if ((**tokens)->kind == TokenKind_Struct) {
		declaration->kind = DeclarationKind_Struct;
		declaration->declaration = (Void*)parseDeclarationStruct(tokens, declaration);
	};;;
	if (declaration->declaration == NULL) { return NULL; };
	return declaration;
};
