func codegenNullExpressionPointer(type: TypePointer*) {
	printf((char*)"(NULL)");
};

func codegenNullExpression(type: Type*) {
	if (type->kind == .Pointer) {
		codegenNullExpressionPointer((TypePointer*)type->type);
	} else {
		fprintf(stderr, (char*)"Invalid type kind %u%c", type->kind, 10);
		abort();
	};
};

func codegenExpressionGroup(expression: Expression*, expr: Expression*) {
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

func codegenExpressionDereference(expression: Expression*, expr: ExpressionDereference*) {
	printf((char*)"(*");
	codegenExpression(expr->expression);
	printf((char*)")");
};

func codegenExpressionReference(expression: Expression*, expr: ExpressionReference*) {
	printf((char*)"(&");
	codegenExpression(expr->expression);
	printf((char*)")");
};

func codegenExpressionSizeof(expression: Expression*, expr: ExpressionSizeof*) {
	printf((char*)"sizeof(");
	codegenType(expr->resolvedType);
	printf((char*)")");
};

func codegenExpressionOffsetof(expression: Expression*, expr: ExpressionOffsetof*) {
	printf((char*)"offsetof(");
	codegenType(expr->resolvedType);
	printf((char*)", ");
	codegenIdentifier(expr->field);
	printf((char*)")");
};

func codegenExpressionFunctionCall(expression: Expression*, expr: ExpressionFunctionCall*) {
	printf((char*)"(");
	codegenExpression(expr->function);
	printf((char*)"(");
	var i = 0;
	while (i < bufferCount((Void**)expr->arguments)) {
		codegenExpression(expr->arguments[i]);
		i = i + 1;
		if (i < bufferCount((Void**)expr->arguments)) { printf((char*)", "); };
	};
	printf((char*)")");
	printf((char*)")");
};

func codegenExpressionSubscript(expression: Expression*, expr: ExpressionSubscript*) {
	printf((char*)"(");
	codegenExpression(expr->base);
	printf((char*)"[");
	codegenExpression(expr->subscript);
	printf((char*)"]");
	printf((char*)")");
};

func codegenExpressionArrow(expression: Expression*, expr: ExpressionArrow*) {
	printf((char*)"(");
	codegenExpression(expr->base);
	printf((char*)"->");
	codegenIdentifier(expr->field);
	printf((char*)")");
};

func codegenExpressionDot(expression: Expression*, expr: ExpressionDot*) {
	printf((char*)"(");
	var i = 0;
	while (i < bufferCount((Void**)_declarations)) {
		if (_declarations[i]->kind == .Enum) {
			if (_declarations[i]->resolvedType == expression->resolvedType) {
				codegenIdentifier(_declarations[i]->name);
			};
		};
		i = i + 1;
	};
	printf((char*)"_");
	codegenIdentifier(expr->field);
	printf((char*)")");
};

func codegenExpressionInfixOperator(expression: Expression*, expr: ExpressionInfix*) {
	printf((char*)"(");
	codegenExpression(expr->lhs);
	printf((char*)" %.*s ", (int)expr->operator->length, expr->operator->value);
	codegenExpression(expr->rhs);
	printf((char*)")");
};

func codegenExpressionIdentifier(expression: Expression*, expr: ExpressionIdentifier*) {
	printf((char*)"(");
	codegenIdentifier(expr->identifier);
	printf((char*)")");
};

func codegenExpressionBooleanLiteral(expression: Expression*, expr: ExpressionBooleanLiteral*) {
	printf((char*)"(");
	printf((char*)"%.*s", (int)expr->literal->length, expr->literal->value);
	printf((char*)")");
};

func codegenExpressionIntegerLiteral(expression: Expression*, expr: ExpressionIntegerLiteral*) {
	printf((char*)"(");
	printf((char*)"%.*s", (int)expr->literal->length, expr->literal->value);
	printf((char*)")");
};

func codegenExpressionCharacterLiteral(expression: Expression*, expr: ExpressionCharacterLiteral*) {
	printf((char*)"((UInt8)");
	printf((char*)"%c%.*s%c", 39, (int)expr->literal->length, expr->literal->value, 39);
	printf((char*)")");
};

func codegenExpressionStringLiteral(expression: Expression*, expr: ExpressionStringLiteral*) {
	printf((char*)"((UInt8*)");
	printf((char*)"%c%.*s%c", 34, (int)expr->literal->length, expr->literal->value, 34);
	printf((char*)")");
};

func codegenExpression(expression: Expression*) {
	if (expression->kind == .Group) {
		codegenExpressionGroup(expression, (Expression*)expression->expression);
	} else if (expression->kind == .Cast) {
		codegenExpressionCast(expression, (ExpressionCast*)expression->expression);
	} else if (expression->kind == .Sizeof) {
		codegenExpressionSizeof(expression, (ExpressionSizeof*)expression->expression);
	} else if (expression->kind == .Offsetof) {
		codegenExpressionOffsetof(expression, (ExpressionOffsetof*)expression->expression);
	} else if (expression->kind == .Dereference) {
		codegenExpressionDereference(expression, (ExpressionDereference*)expression->expression);
	} else if (expression->kind == .Reference) {
		codegenExpressionReference(expression, (ExpressionReference*)expression->expression);
	} else if (expression->kind == .FunctionCall) {
		codegenExpressionFunctionCall(expression, (ExpressionFunctionCall*)expression->expression);
	} else if (expression->kind == .Subscript) {
		codegenExpressionSubscript(expression, (ExpressionSubscript*)expression->expression);
	} else if (expression->kind == .Arrow) {
		codegenExpressionArrow(expression, (ExpressionArrow*)expression->expression);
	} else if (expression->kind == .Dot) {
		codegenExpressionDot(expression, (ExpressionDot*)expression->expression);
	} else if (expression->kind == .InfixOperator) {
		codegenExpressionInfixOperator(expression, (ExpressionInfix*)expression->expression);
	} else if (expression->kind == .Identifier) {
		codegenExpressionIdentifier(expression, (ExpressionIdentifier*)expression->expression);
	} else if (expression->kind == ._NULL) {
		printf((char*)"NULL");
	} else if (expression->kind == .BooleanLiteral) {
		codegenExpressionBooleanLiteral(expression, (ExpressionBooleanLiteral*)expression->expression);
	} else if (expression->kind == .IntegerLiteral) {
		codegenExpressionIntegerLiteral(expression, (ExpressionIntegerLiteral*)expression->expression);
	} else if (expression->kind == .CharacterLiteral) {
		codegenExpressionCharacterLiteral(expression, (ExpressionCharacterLiteral*)expression->expression);
	} else if (expression->kind == .StringLiteral) {
		codegenExpressionStringLiteral(expression, (ExpressionStringLiteral*)expression->expression);
	} else {
		fprintf(stderr, (char*)"Invalid expression kind %u%c", expression->kind, 10);
		abort();
	};;;;;;;;;;;;;;;;;
};
