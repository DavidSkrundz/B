func expectDeclarationVar(declaration: Declaration*): DeclarationVar* {
	expectKeyword(Keyword_Var);
	declaration->pos = previousToken()->pos;
	declaration->name = expectIdentifier();
	var decl = newDeclarationVar();
	if (checkToken(.Colon)) {
		decl->type = expectTypespec();
	};
	if (checkToken(.Assign)) {
		decl->value = expectExpression();
	};
	expectToken(.Semicolon);
	if (decl->type == NULL && decl->value == NULL) { ParserErrorTmp("expecting type or value to not be null"); };
	return decl;
};

func parseDeclarationFuncArgument(): DeclarationFuncArg* {
	var arg = newDeclarationFuncArg();
	arg->name = parseIdentifier();
	if (arg->name == NULL) { return NULL; };
	arg->pos = arg->name->pos;
	expectToken(.Colon);
	arg->type = expectTypespec();
	return arg;
};

func expectDeclarationFuncArguments(): DeclarationFuncArgs* {
	expectToken(.OpenParenthesis);
	var args = newDeclarationFuncArgs();
	var arg = parseDeclarationFuncArgument();
	if (arg != NULL) {
		Buffer_append((Void***)&args->args, (Void*)arg);
	};
	while (checkToken(.Comma)) {
		var arg2 = parseDeclarationFuncArgument();
		if (arg2 != NULL) {
			Buffer_append((Void***)&args->args, (Void*)arg2);
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
	declaration->pos = previousToken()->pos;
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
	declaration->pos = previousToken()->pos;
	declaration->name = expectIdentifier();
	var decl = newDeclarationStruct();
	if (checkToken(.OpenCurly)) {
		while (isToken(.CloseCurly) == false) {
			var subDecl = expectDeclaration();
			if (subDecl->kind == .Var) {
				Buffer_append((Void***)&decl->fields, (Void*)subDecl);
			} else if (subDecl->kind == .Func) {
				Buffer_append((Void***)&decl->functions, (Void*)subDecl);
			} else {
				ParserErrorTmp("expecting var or func declaration");
			};;
		};
		expectToken(.CloseCurly);
	};
	expectToken(.Semicolon);
	return decl;
};

func expectDeclarationEnum(declaration: Declaration*): DeclarationEnum* {
	expectKeyword(Keyword_Enum);
	declaration->pos = previousToken()->pos;
	declaration->name = expectIdentifier();
	var decl = newDeclarationEnum();
	expectToken(.OpenCurly);
	while (isToken(.CloseCurly) == false) {
		expectKeyword(Keyword_Case);
		var caseName = expectIdentifier();
		expectToken(.Semicolon);
		var i = 0;
		while (i < Buffer_getCount((Void**)decl->cases)) {
			if (decl->cases[i]->name->string == caseName->string) {
				fprintf(stderr, (char*)"Duplicate enum case %s\n", caseName->string->string);
				exit(EXIT_FAILURE);
			};
			i = i + 1;
		};
		var enumCase = newDeclarationEnumCase();
		enumCase->name = caseName;
		Buffer_append((Void***)&decl->cases, (Void*)enumCase);
	};
	expectToken(.CloseCurly);
	expectToken(.Semicolon);
	return decl;
};

func expectDeclaration(): Declaration* {
	var declaration = newDeclaration();
	declaration->attribute = parseAttribute();
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
