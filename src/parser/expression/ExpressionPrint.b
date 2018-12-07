func printExpressionGroup(expression: Expression*) {
	printf((char*)"(");
	printExpression(expression);
	printf((char*)")");
};

func printExpressionCast(expression: ExpressionCast*) {
	printf((char*)"(cast ");
	printTypespec(expression->type);
	printf((char*)" ");
	printExpression((Expression*)expression->expression);
	printf((char*)")");
};

func printExpressionSizeof(expression: ExpressionSizeof*) {
	printf((char*)"(sizeof ");
	printTypespec(expression->type);
	printf((char*)")");
};

func printExpressionOffsetOf(expression: ExpressionOffsetof*) {
	printf((char*)"(offsetof ");
	printTypespec(expression->type);
	printf((char*)" ");
	printIdentifier(expression->field);
	printf((char*)")");
};

func printExpressionDereference(expression: ExpressionDereference*) {
	printf((char*)"(dereference ");
	printExpression((Expression*)expression->expression);
	printf((char*)")");
};

func printExpressionReference(expression: ExpressionReference*) {
	printf((char*)"(reference ");
	printExpression((Expression*)expression->expression);
	printf((char*)")");
};

func printExpressionFunctionCall(expression: ExpressionFunctionCall*) {
	printf((char*)"(call ");
	depth = depth + 1;
	printExpression(expression->function);
	printf((char*)"\n");
	var i = 0;
	while (i < Buffer_getCount((Void**)expression->arguments)) {
		printDepth();
		printExpression(expression->arguments[i]);
		printf((char*)"\n");
		i = i + 1;
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionSubscript(expression: ExpressionSubscript*) {
	printf((char*)"(subscript\n");
	depth = depth + 1;
	printDepth();
	printExpression(expression->base);
	printf((char*)"\n");
	printDepth();
	printExpression(expression->subscript);
	printf((char*)"\n");
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionArrow(expression: ExpressionArrow*) {
	printf((char*)"(->\n");
	depth = depth + 1;
	printDepth();
	printExpression(expression->base);
	printf((char*)"\n");
	printDepth();
	printIdentifier(expression->field);
	printf((char*)"\n");
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionDot(expression: ExpressionDot*) {
	printf((char*)"(dot\n");
	depth = depth + 1;
	if (expression->base != NULL) {
		printDepth();
		printIdentifier(expression->base);
		printf((char*)"\n");
	};
	printDepth();
	printIdentifier(expression->field);
	printf((char*)"\n");
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionPrefix(expression: ExpressionPrefix*) {
	printf((char*)"(");
	printToken(expression->operator);
	printf((char*)" ");
	printExpression(expression->expression);
	printf((char*)")");
};

func printExpressionInfix(expression: ExpressionInfix*) {
	printf((char*)"(");
	printToken(expression->operator);
	printf((char*)"\n");
	depth = depth + 1;
	printDepth();
	printExpression(expression->lhs);
	printf((char*)"\n");
	printDepth();
	printExpression(expression->rhs);
	printf((char*)"\n");
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionTernary(expression: ExpressionTernary*) {
	printf((char*)"(?:");
	printf((char*)"\n");
	depth = depth + 1;
	printDepth();
	printExpression(expression->condition);
	printf((char*)"\n");
	printDepth();
	printExpression(expression->positive);
	printf((char*)"\n");
	printDepth();
	printExpression(expression->negative);
	printf((char*)"\n");
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionIdentifier(expression: ExpressionIdentifier*) {
	printIdentifier(expression->identifier);
};

func printExpressionBooleanLiteral(expression: ExpressionBooleanLiteral*) {
	printf((char*)"(boolean %s)", expression->literal->string->string);
};

func printExpressionIntegerLiteral(expression: ExpressionIntegerLiteral*) {
	printf((char*)"(integer %s)", expression->literal->string->string);
};

func printExpressionCharacterLiteral(expression: ExpressionCharacterLiteral*) {
	printf((char*)"(character %s)", expression->literal->string->string);
};

func printExpressionStringLiteral(expression: ExpressionStringLiteral*) {
	printf((char*)"(string %s)", expression->literal->string->string);
};

func printExpression(expression: Expression*) {
	if (expression->kind == .Group) {
		printExpressionGroup((Expression*)expression->expression);
	} else if (expression->kind == .Cast) {
		printExpressionCast((ExpressionCast*)expression->expression);
	} else if (expression->kind == .Sizeof) {
		printExpressionSizeof((ExpressionSizeof*)expression->expression);
	} else if (expression->kind == .Offsetof) {
		printExpressionOffsetOf((ExpressionOffsetof*)expression->expression);
	} else if (expression->kind == .Dereference) {
		printExpressionDereference((ExpressionDereference*)expression->expression);
	} else if (expression->kind == .Reference) {
		printExpressionReference((ExpressionReference*)expression->expression);
	} else if (expression->kind == .FunctionCall) {
		printExpressionFunctionCall((ExpressionFunctionCall*)expression->expression);
	} else if (expression->kind == .Subscript) {
		printExpressionSubscript((ExpressionSubscript*)expression->expression);
	} else if (expression->kind == .Arrow) {
		printExpressionArrow((ExpressionArrow*)expression->expression);
	} else if (expression->kind == .Dot) {
		printExpressionDot((ExpressionDot*)expression->expression);
	} else if (expression->kind == .PrefixOperator) {
		printExpressionPrefix((ExpressionPrefix*)expression->expression);
	} else if (expression->kind == .InfixOperator) {
		printExpressionInfix((ExpressionInfix*)expression->expression);
	} else if (expression->kind == .Ternary) {
		printExpressionTernary((ExpressionTernary*)expression->expression);
	} else if (expression->kind == .Identifier) {
		printExpressionIdentifier((ExpressionIdentifier*)expression->expression);
	} else if (expression->kind == .Null) {
		printf((char*)"NULL");
	} else if (expression->kind == .BooleanLiteral) {
		printExpressionBooleanLiteral((ExpressionBooleanLiteral*)expression->expression);
	} else if (expression->kind == .IntegerLiteral) {
		printExpressionIntegerLiteral((ExpressionIntegerLiteral*)expression->expression);
	} else if (expression->kind == .CharacterLiteral) {
		printExpressionCharacterLiteral((ExpressionCharacterLiteral*)expression->expression);
	} else if (expression->kind == .StringLiteral) {
		printExpressionStringLiteral((ExpressionStringLiteral*)expression->expression);
	} else if (expression->kind == .Invalid) {
		fprintf(stderr, (char*)"Invalid expression kind %u\n", expression->kind);
		Abort();
	} else {
		fprintf(stderr, (char*)"Invalid expression kind %u\n", expression->kind);
		Abort();
	};;;;;;;;;;;;;;;;;;;;
};
