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
	printf((char*)"%c", 10);
	var i = 0;
	while (i < expression->count) {
		printDepth();
		printExpression(expression->arguments[i]);
		printf((char*)"%c", 10);
		i = i + 1;
	};
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionSubscript(expression: ExpressionSubscript*) {
	printf((char*)"(subscript%c", 10);
	depth = depth + 1;
	printDepth();
	printExpression(expression->base);
	printf((char*)"%c", 10);
	printDepth();
	printExpression(expression->subscript);
	printf((char*)"%c", 10);
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionArrow(expression: ExpressionArrow*) {
	printf((char*)"(->%c", 10);
	depth = depth + 1;
	printDepth();
	printExpression(expression->base);
	printf((char*)"%c", 10);
	printDepth();
	printIdentifier(expression->field);
	printf((char*)"%c", 10);
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionDot(expression: ExpressionDot*) {
	printf((char*)"(dot%c", 10);
	depth = depth + 1;
	if (expression->base != NULL) {
		printDepth();
		printIdentifier(expression->base);
		printf((char*)"%c", 10);
	};
	printDepth();
	printIdentifier(expression->field);
	printf((char*)"%c", 10);
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionInfix(expression: ExpressionInfix*) {
	printf((char*)"(");
	printToken(expression->operator);
	printf((char*)"%c", 10);
	depth = depth + 1;
	printDepth();
	printExpression(expression->lhs);
	printf((char*)"%c", 10);
	printDepth();
	printExpression(expression->rhs);
	printf((char*)"%c", 10);
	depth = depth - 1;
	printDepth();
	printf((char*)")");
};

func printExpressionIdentifier(expression: ExpressionIdentifier*) {
	printIdentifier(expression->identifier);
};

func printExpressionBooleanLiteral(expression: ExpressionBooleanLiteral*) {
	printf((char*)"(boolean %.*s)", (int)expression->literal->length, expression->literal->value);
};

func printExpressionIntegerLiteral(expression: ExpressionIntegerLiteral*) {
	printf((char*)"(integer %.*s)", (int)expression->literal->length, expression->literal->value);
};

func printExpressionCharacterLiteral(expression: ExpressionCharacterLiteral*) {
	printf((char*)"(character %.*s)", (int)expression->literal->length, expression->literal->value);
};

func printExpressionStringLiteral(expression: ExpressionStringLiteral*) {
	printf((char*)"(string %c%.*s%c)", 34, (int)expression->literal->length, expression->literal->value, 34);
};

func printExpression(expression: Expression*) {
	if (expression->kind == ExpressionKind_Group) {
		printExpressionGroup((Expression*)expression->expression);
	} else if (expression->kind == ExpressionKind_Cast) {
		printExpressionCast((ExpressionCast*)expression->expression);
	} else if (expression->kind == ExpressionKind_Sizeof) {
		printExpressionSizeof((ExpressionSizeof*)expression->expression);
	} else if (expression->kind == ExpressionKind_Offsetof) {
		printExpressionOffsetOf((ExpressionOffsetof*)expression->expression);
	} else if (expression->kind == ExpressionKind_Dereference) {
		printExpressionDereference((ExpressionDereference*)expression->expression);
	} else if (expression->kind == ExpressionKind_Reference) {
		printExpressionReference((ExpressionReference*)expression->expression);
	} else if (expression->kind == ExpressionKind_FunctionCall) {
		printExpressionFunctionCall((ExpressionFunctionCall*)expression->expression);
	} else if (expression->kind == ExpressionKind_Subscript) {
		printExpressionSubscript((ExpressionSubscript*)expression->expression);
	} else if (expression->kind == ExpressionKind_Arrow) {
		printExpressionArrow((ExpressionArrow*)expression->expression);
	} else if (expression->kind == ExpressionKind_Dot) {
		printExpressionDot((ExpressionDot*)expression->expression);
	} else if (expression->kind == ExpressionKind_InfixOperator) {
		printExpressionInfix((ExpressionInfix*)expression->expression);
	} else if (expression->kind == ExpressionKind_Identifier) {
		printExpressionIdentifier((ExpressionIdentifier*)expression->expression);
	} else if (expression->kind == ExpressionKind_NULL) {
		printf((char*)"NULL");
	} else if (expression->kind == ExpressionKind_BooleanLiteral) {
		printExpressionBooleanLiteral((ExpressionBooleanLiteral*)expression->expression);
	} else if (expression->kind == ExpressionKind_IntegerLiteral) {
		printExpressionIntegerLiteral((ExpressionIntegerLiteral*)expression->expression);
	} else if (expression->kind == ExpressionKind_CharacterLiteral) {
		printExpressionCharacterLiteral((ExpressionCharacterLiteral*)expression->expression);
	} else if (expression->kind == ExpressionKind_StringLiteral) {
		printExpressionStringLiteral((ExpressionStringLiteral*)expression->expression);
	} else {
		fprintf(stderr, (char*)"Invalid expression kind %zu%c", expression->kind, 10);
		abort();
	};;;;;;;;;;;;;;;;;
};
