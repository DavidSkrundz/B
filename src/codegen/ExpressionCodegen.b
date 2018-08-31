func codegenNullExpression(symbol: Symbol*) {
	if (symbol->type->kind == .Pointer) {
		printf((char*)"(NULL)");
	} else {
		ProgrammingError("called codegenNullExpression on a .Invalid");
	};
};

func codegenExpressionGroup(expr: Expression*) {
	printf((char*)"(");
	codegenExpression(expr);
	printf((char*)")");
};

func codegenExpressionCast(expression: Expression*, expr: ExpressionCast*) {
	printf((char*)"(");
	codegenType(expression->resolvedType);
	printf((char*)")(");
	codegenExpression(expr->expression);
	printf((char*)")");
};

func codegenExpressionDereference(expr: ExpressionDereference*) {
	printf((char*)"(*");
	codegenExpression(expr->expression);
	printf((char*)")");
};

func codegenExpressionReference(expr: ExpressionReference*) {
	printf((char*)"(&");
	codegenExpression(expr->expression);
	printf((char*)")");
};

func codegenExpressionSizeof(expr: ExpressionSizeof*) {
	printf((char*)"sizeof(");
	codegenType(expr->resolvedType);
	printf((char*)")");
};

func codegenExpressionOffsetof(expr: ExpressionOffsetof*) {
	printf((char*)"offsetof(");
	codegenType(expr->resolvedType);
	printf((char*)", ");
	codegenIdentifier(expr->field->string);
	printf((char*)")");
};

func codegenExpressionFunctionCall(expr: ExpressionFunctionCall*) {
	printf((char*)"(");
	codegenExpression(expr->function);
	printf((char*)"(");
	if (expr->function->kind == .Arrow) {
		var arrow = (ExpressionArrow*)expr->function->expression;
		codegenExpression(arrow->base);
		if (Buffer_getCount((Void**)expr->arguments) > 0) { printf((char*)", "); };
	};
	var i = 0;
	while (i < Buffer_getCount((Void**)expr->arguments)) {
		codegenExpression(expr->arguments[i]);
		i = i + 1;
		if (i < Buffer_getCount((Void**)expr->arguments)) { printf((char*)", "); };
	};
	printf((char*)")");
	printf((char*)")");
};

func codegenExpressionSubscript(expr: ExpressionSubscript*) {
	printf((char*)"(");
	codegenExpression(expr->base);
	printf((char*)"[");
	codegenExpression(expr->subscript);
	printf((char*)"]");
	printf((char*)")");
};

func codegenExpressionArrow(expression: Expression*, expr: ExpressionArrow*) {
	if (expression->resolvedType->kind != .Function) {
		printf((char*)"(");
		codegenExpression(expr->base);
		printf((char*)"->");
		codegenIdentifier(expr->field->string);
		printf((char*)")");
	} else {
		var pointerType = expr->base->resolvedType;
		var baseType = getPointerBase(pointerType);
		var structSymbol = findSymbolByType(baseType);
		
		pushContextChain();
		restoreContextFromRoot(structSymbol->children);
		var fieldSymbol = findSymbol(expr->field->string);
		popContextChain();
		
		codegenIdentifier(fieldSymbol->parent->name);
		printf((char*)"_");
		codegenIdentifier(expr->field->string);
	};
};

func codegenExpressionDot(expression: Expression*, expr: ExpressionDot*) {
	printf((char*)"(");
	var enumSymbol = findSymbolByType(expression->resolvedType);
	codegenIdentifier(enumSymbol->name);
	printf((char*)"_");
	codegenIdentifier(expr->field->string);
	printf((char*)")");
};

func codegenExpressionPrefixOperator(expr: ExpressionPrefix*) {
	printf((char*)"(");
	String_print(stdout, expr->operator->string);
	codegenExpression(expr->expression);
	printf((char*)")");
};

func codegenExpressionInfixOperator(expr: ExpressionInfix*) {
	printf((char*)"(");
	codegenExpression(expr->lhs);
	printf((char*)" ");
	String_print(stdout, expr->operator->string);
	printf((char*)" ");
	codegenExpression(expr->rhs);
	printf((char*)")");
};

func codegenExpressionTernary(expr: ExpressionTernary*) {
	printf((char*)"(");
	codegenExpression(expr->condition);
	printf((char*)" ? ");
	codegenExpression(expr->positive);
	printf((char*)" : ");
	codegenExpression(expr->negative);
	printf((char*)")");
};

func codegenExpressionIdentifier(expr: ExpressionIdentifier*) {
	printf((char*)"(");
	codegenIdentifier(expr->identifier->string);
	printf((char*)")");
};

func codegenExpressionBooleanLiteral(expr: ExpressionBooleanLiteral*) {
	printf((char*)"(");
	String_print(stdout, expr->literal->string);
	printf((char*)")");
};

func codegenExpressionIntegerLiteral(expr: ExpressionIntegerLiteral*) {
	printf((char*)"(");
	String_print(stdout, expr->literal->string);
	printf((char*)")");
};

func codegenExpressionCharacterLiteral(expr: ExpressionCharacterLiteral*) {
	printf((char*)"((UInt8)'");
	String_print_escaped(stdout, expr->literal->string);
	printf((char*)"')");
};

func codegenExpressionStringLiteral(expr: ExpressionStringLiteral*) {
	printf((char*)"((UInt8*)\"");
	String_print_escaped(stdout, expr->literal->string);
	printf((char*)"\")");
};

func codegenExpression(expression: Expression*) {
	if (expression->kind == .Group) {
		codegenExpressionGroup((Expression*)expression->expression);
	} else if (expression->kind == .Cast) {
		codegenExpressionCast(expression, (ExpressionCast*)expression->expression);
	} else if (expression->kind == .Sizeof) {
		codegenExpressionSizeof((ExpressionSizeof*)expression->expression);
	} else if (expression->kind == .Offsetof) {
		codegenExpressionOffsetof((ExpressionOffsetof*)expression->expression);
	} else if (expression->kind == .Dereference) {
		codegenExpressionDereference((ExpressionDereference*)expression->expression);
	} else if (expression->kind == .Reference) {
		codegenExpressionReference((ExpressionReference*)expression->expression);
	} else if (expression->kind == .FunctionCall) {
		codegenExpressionFunctionCall((ExpressionFunctionCall*)expression->expression);
	} else if (expression->kind == .Subscript) {
		codegenExpressionSubscript((ExpressionSubscript*)expression->expression);
	} else if (expression->kind == .Arrow) {
		codegenExpressionArrow(expression, (ExpressionArrow*)expression->expression);
	} else if (expression->kind == .Dot) {
		codegenExpressionDot(expression, (ExpressionDot*)expression->expression);
	} else if (expression->kind == .PrefixOperator) {
		codegenExpressionPrefixOperator((ExpressionPrefix*)expression->expression);
	} else if (expression->kind == .InfixOperator) {
		codegenExpressionInfixOperator((ExpressionInfix*)expression->expression);
	} else if (expression->kind == .Ternary) {
		codegenExpressionTernary((ExpressionTernary*)expression->expression);
	} else if (expression->kind == .Identifier) {
		codegenExpressionIdentifier((ExpressionIdentifier*)expression->expression);
	} else if (expression->kind == .Null) {
		printf((char*)"NULL");
	} else if (expression->kind == .BooleanLiteral) {
		codegenExpressionBooleanLiteral((ExpressionBooleanLiteral*)expression->expression);
	} else if (expression->kind == .IntegerLiteral) {
		codegenExpressionIntegerLiteral((ExpressionIntegerLiteral*)expression->expression);
	} else if (expression->kind == .CharacterLiteral) {
		codegenExpressionCharacterLiteral((ExpressionCharacterLiteral*)expression->expression);
	} else if (expression->kind == .StringLiteral) {
		codegenExpressionStringLiteral((ExpressionStringLiteral*)expression->expression);
	} else {
		ProgrammingError("called codegenExpression on a .Invalid");
	};;;;;;;;;;;;;;;;;;;
};
