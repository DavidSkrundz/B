func expectDeclarationVar(declaration: Declaration*): DeclarationVar* {
	expectKeyword(Keyword_Var);
	declaration->name = expectIdentifier();
	var decl = newDeclarationVar();
	if (checkToken(.Colon)) {
		decl->type = expectTypespec();
	};
	if (checkToken(.Assign)) {
		decl->value = parseExpression(&_tokens);
		if (decl->value == NULL) { ParserErrorTmp("expected expression"); };
	};
	expectToken(.Semicolon);
	if (decl->type == NULL && decl->value == NULL) { return NULL; };
	return decl;
};

func parseDeclarationFuncArgument(): DeclarationFuncArg* {
	var arg = newDeclarationFuncArg();
	arg->name = parseIdentifier(&_tokens);
	if (arg->name == NULL) { return NULL; };
	expectToken(.Colon);
	arg->type = expectTypespec();
	return arg;
};

func expectDeclarationFuncArguments(): DeclarationFuncArgs* {
	expectToken(.OpenParenthesis);
	var args = newDeclarationFuncArgs();
	var arg = parseDeclarationFuncArgument();
	if (arg != NULL) {
		append((Void***)&args->args, (Void*)arg);
	};
	while (checkToken(.Comma)) {
		var arg2 = parseDeclarationFuncArgument();
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

func expectDeclarationFunc(declaration: Declaration*): DeclarationFunc* {
	expectKeyword(Keyword_Func);
	declaration->name = expectIdentifier();
	var decl = newDeclarationFunc();
	decl->args = expectDeclarationFuncArguments();
	if (checkToken(.Colon)) {
		decl->returnType = expectTypespec();
	};
	if (isToken(.OpenCurly)) {
		decl->block = expectStatementBlock();
	};
	expectToken(.Semicolon);
	return decl;
};

func expectDeclarationStruct(declaration: Declaration*): DeclarationStruct* {
	expectKeyword(Keyword_Struct);
	declaration->name = expectIdentifier();
	var decl = newDeclarationStruct();
	if (checkToken(.OpenCurly)) {
		while (isToken(.CloseCurly) == false) {
			var varDecl = expectDeclaration();
			if (varDecl->kind != .Var) { ParserErrorTmp("expecting var declaration"); };
			append((Void***)&decl->fields, (Void*)varDecl);
		};
		expectToken(.CloseCurly);
	};
	expectToken(.Semicolon);
	return decl;
};

func expectDeclarationEnum(declaration: Declaration*): DeclarationEnum* {
	expectKeyword(Keyword_Enum);
	declaration->name = expectIdentifier();
	var decl = newDeclarationEnum();
	expectToken(.OpenCurly);
	while (isToken(.CloseCurly) == false) {
		expectKeyword(Keyword_Case);
		var caseName = expectIdentifier();
		expectToken(.Semicolon);
		var i = 0;
		while (i < bufferCount((Void**)decl->cases)) {
			if (decl->cases[i]->name->name == caseName->name) {
				fprintf(stderr, (char*)"Duplicate enum case %s\n", caseName->name);
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

func expectDeclaration(): Declaration* {
	var declaration = newDeclaration();
	declaration->attribute = parseAttribute(&_tokens);
	declaration->state = .Unresolved;
	if (isTokenKeyword(Keyword_Var)) {
		declaration->kind = .Var;
		declaration->declaration = (Void*)expectDeclarationVar(declaration);
	} else if (isTokenKeyword(Keyword_Func)) {
		declaration->kind = .Func;
		declaration->declaration = (Void*)expectDeclarationFunc(declaration);
	} else if (isTokenKeyword(Keyword_Struct)) {
		declaration->kind = .Struct;
		declaration->declaration = (Void*)expectDeclarationStruct(declaration);
	} else if (isTokenKeyword(Keyword_Enum)) {
		declaration->kind = .Enum;
		declaration->declaration = (Void*)expectDeclarationEnum(declaration);
	} else {
		ParserErrorTmp("expecting declaration");
	};;;;
	return declaration;
};
