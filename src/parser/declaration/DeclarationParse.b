func parseDeclarationVar(tokens: Token***, declaration: Declaration*): DeclarationVar* {
	expectKeyword(Keyword_Var);
	declaration->name = expectIdentifier();
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

func parseDeclarationFuncArgument(tokens: Token***): DeclarationFuncArg* {
	var arg = newDeclarationFuncArg();
	arg->name = parseIdentifier(tokens);
	if (arg->name == NULL) { return NULL; };
	expectToken(.Colon);
	arg->type = parseTypespec(tokens);
	if (arg->type == NULL) { return NULL; };
	return arg;
};

func parseDeclarationFuncArguments(tokens: Token***): DeclarationFuncArgs* {
	expectToken(.OpenParenthesis);
	var args = newDeclarationFuncArgs();
	var arg = parseDeclarationFuncArgument(tokens);
	if (arg != NULL) {
		append((Void***)&args->args, (Void*)arg);
	};
	while (checkToken(.Comma)) {
		var arg2 = parseDeclarationFuncArgument(tokens);
		if (arg2 != NULL) {
			append((Void***)&args->args, (Void*)arg2);
		};
	};
	if (checkToken(.Ellipses)) {
		args->isVariadic = true;
	};
	expectToken(.CloseParenthesis);
	return args;
};

func parseDeclarationFunc(tokens: Token***, declaration: Declaration*): DeclarationFunc* {
	expectKeyword(Keyword_Func);
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
	expectKeyword(Keyword_Struct);
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; };
	var decl = newDeclarationStruct();
	if (checkToken(.OpenCurly)) {
		while ((**tokens)->kind != .CloseCurly) {
			var varDecl = parseDeclaration(tokens);
			if (varDecl == NULL) { return NULL; };
			if (varDecl->kind != .Var) { return NULL; };
			append((Void***)&decl->fields, (Void*)varDecl);
		};
		expectToken(.CloseCurly);
	};
	expectToken(.Semicolon);
	return decl;
};

func parseDeclarationEnum(tokens: Token***, declaration: Declaration*): DeclarationEnum* {
	expectKeyword(Keyword_Enum);
	declaration->name = parseIdentifier(tokens);
	if (declaration->name == NULL) { return NULL; };
	var decl = newDeclarationEnum();
	expectToken(.OpenCurly);
	while ((**tokens)->kind != .CloseCurly) {
		expectKeyword(Keyword_Case);
		var caseName = parseIdentifier(tokens);
		if (caseName == NULL) { return NULL; };
		expectToken(.Semicolon);
		var i = 0;
		while (i < bufferCount((Void**)decl->cases)) {
			if (decl->cases[i]->name->name == caseName->name) {
				fprintf(stderr, (char*)"Duplicate enum case %s%c", caseName->name, 10);
				exit(EXIT_FAILURE);
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
	declaration->state = .Unresolved;
	if (isTokenKeyword(Keyword_Var)) {
		declaration->kind = .Var;
		declaration->declaration = (Void*)parseDeclarationVar(tokens, declaration);
	} else if (isTokenKeyword(Keyword_Func)) {
		declaration->kind = .Func;
		declaration->declaration = (Void*)parseDeclarationFunc(tokens, declaration);
	} else if (isTokenKeyword(Keyword_Struct)) {
		declaration->kind = .Struct;
		declaration->declaration = (Void*)parseDeclarationStruct(tokens, declaration);
	} else if (isTokenKeyword(Keyword_Enum)) {
		declaration->kind = .Enum;
		declaration->declaration = (Void*)parseDeclarationEnum(tokens, declaration);
	};;;;
	if (declaration->declaration == NULL) { return NULL; };
	return declaration;
};
