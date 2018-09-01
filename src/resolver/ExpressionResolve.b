func resolveExpressionCast(expression: ExpressionCast*, expectedType: Type*): Type* {
	resolveExpression(expression->expression, NULL);
	var castType = resolveTypespec(expression->type);
	if (castType == NULL) {
		ProgrammingError("cast type is NULL");
	};
	if (expectedType != NULL && expectedType != castType) {
		ResolverError(expression->type->pos, "cast to wrong type", "", "");
	};
	return castType;
};

func resolveExpressionSizeof(expression: ExpressionSizeof*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeUInt) {
		ResolverError(expression->type->pos, "not expecting UInt result from sizeof operator", "", "");
	};
	expression->resolvedType = resolveTypespec(expression->type);
	return TypeUInt;
};

func resolveExpressionOffsetof(expression: ExpressionOffsetof*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeUInt) {
		ResolverError(expression->type->pos, "not expecting UInt result from offsetof operator", "", "");
	};
	var structType = resolveTypespec(expression->type);
	var structSymbol = findSymbolByType(structType);
	if (structSymbol == NULL) {
		ResolverError(expression->type->pos, "unknown type", "", "");
	};
	pushContextChain();
	restoreContextFromRoot(structSymbol->children);
	var fieldSymbol = findSymbol(expression->field->string);
	popContextChain();
	if (fieldSymbol == NULL) {
		ResolverError(expression->field->pos, "struct field '", expression->field->string->string, "' not found");
	};
	expression->resolvedType = structType;
	return TypeUInt;
};

func resolveExpressionDereference(expression: ExpressionDereference*, expectedType: Type*): Type* {
	var expectedBaseType: Type*;
	if (expectedType != NULL) {
		expectedBaseType = resolveTypePointer(expectedType);
	};
	var baseType = resolveExpression(expression->expression, expectedBaseType);
	if (isPointer(baseType) == false) {
		ResolverError(expression->expression->pos, "unable to dereference non-pointer", "", "");
	};
	return getPointerBase(baseType);
};

func resolveExpressionReference(expression: ExpressionReference*, expectedType: Type*): Type* {
	var expectedPointerType: Type*;
	if (expectedType != NULL) {
		expectedPointerType = getPointerBase(expectedType);
	};
	var type = resolveExpression(expression->expression, expectedPointerType);
	return resolveTypePointer(type);
};

func resolveExpressionFunctionCall(expression: ExpressionFunctionCall*, expectedType: Type*): Type* {
	var functionType = resolveExpression(expression->function, NULL);
	if (functionType->kind != .Function) {
		ResolverError(expression->function->pos, "unable to call non-function", "", "");
	};
	var funcType = (TypeFunction*)functionType->type;
	if (expectedType != NULL && expectedType != funcType->returnType) {
		ResolverError(expression->function->pos, "function call returns wrong type", "", "");
	};
	
	var requiredArgumentCount = Buffer_getCount((Void**)funcType->argumentTypes);
	if (Buffer_getCount((Void**)expression->arguments) < requiredArgumentCount) {
		ResolverError(expression->function->pos, "not enough arguments in function call", "", "");
	};
	if (requiredArgumentCount < Buffer_getCount((Void**)expression->arguments) && funcType->isVariadic == false) {
		ResolverError(expression->function->pos, "too many arguments in function call", "", "");
	};
	var i = 0;
	while (i < Buffer_getCount((Void**)funcType->argumentTypes)) {
		resolveExpression(expression->arguments[i], funcType->argumentTypes[i]);
		i = i + 1;
	};
	while (i < Buffer_getCount((Void**)expression->arguments)) {
		resolveExpression(expression->arguments[i], NULL);
		i = i + 1;
	};
	
	return funcType->returnType;
};

func resolveExpressionSubscript(expression: ExpressionSubscript*, expectedType: Type*): Type* {
	var expectedBaseType: Type*;
	if (expectedType != NULL) {
		expectedBaseType = resolveTypePointer(expectedType);
	};
	var baseType = resolveExpression(expression->base, expectedBaseType);
	if (isPointer(baseType) == false) {
		ResolverError(expression->base->pos, "cannot subscript non-pointer", "", "");
	};
	resolveExpression(expression->subscript, TypeUInt);
	return getPointerBase(baseType);
};

func resolveExpressionArrow(expression: ExpressionArrow*, expectedType: Type*): Type* {
	var pointerType = resolveExpression(expression->base, NULL);
	var baseType = getPointerBase(pointerType);
	var structSymbol = findSymbolByType(baseType);
	if (structSymbol == NULL || structSymbol->isType == false) {
		ResolverError(expression->base->pos, "unable to apply -> to non-struct pointer", "", "");
	};
	
	pushContextChain();
	restoreContextFromRoot(structSymbol->children);
	var fieldSymbol = findSymbol(expression->field->string);
	popContextChain();
	if (fieldSymbol != NULL) {
		if (expectedType == NULL || expectedType == fieldSymbol->type) {
			return fieldSymbol->type;
		};
		ResolverError(expression->field->pos, "struct field '", expression->field->string->string, "' is wrong type");
	};
	ResolverError(expression->field->pos, "struct field '", expression->field->string->string, "' not found");
	return NULL;
};

func resolveExpressionDotInner(symbol: Symbol*, expression: ExpressionDot*): Type* {
	pushContextChain();
	restoreContextFromRoot(symbol->children);
	var fieldSymbol = findSymbol(expression->field->string);
	popContextChain();
	if (fieldSymbol != NULL) { return symbol->type; };
	ResolverError(expression->field->pos, "enum field '", expression->field->string->string, "' not found");
	return NULL;
};

func resolveExpressionDot(expression: ExpressionDot*, expectedType: Type*): Type* {
	if (expression->base == NULL) {
		var symbol = findSymbolByType(expectedType);
		return resolveExpressionDotInner(symbol, expression);
	};
	
	var symbol = resolveSymbol(expression->base->string);
	if (symbol != NULL && symbol->isType) {
		if (expectedType == NULL || expectedType == symbol->type) {
			return resolveExpressionDotInner(symbol, expression);
		};
	};
	ResolverError(expression->field->pos, "enum '", expression->base->string->string, "' not found");
	return NULL;
};

func resolveExpressionInfixComparison(expression: ExpressionInfix*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeBool) {
		ResolverError(expression->operator->pos, "not expecting boolean result from comparison operator", "", "");
	};
	var lhs = resolveExpression(expression->lhs, NULL);
	resolveExpression(expression->rhs, lhs);
	return TypeBool;
};

func resolveExpressionInfixAddition(expression: ExpressionInfix*, expectedType: Type*): Type* {
	var lhs = resolveExpression(expression->lhs, expectedType);
	var rhs = resolveExpression(expression->rhs, lhs);
	return rhs;
};

func resolveExpressionInfixMultiplication(expression: ExpressionInfix*, expectedType: Type*): Type* {
	var lhs = resolveExpression(expression->lhs, expectedType);
	var rhs = resolveExpression(expression->rhs, lhs);
	return rhs;
};

func resolveExpressionInfixLogical(expression: ExpressionInfix*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeBool) {
		ResolverError(expression->operator->pos, "not expecting boolean result from logical operator", "", "");
	};
	resolveExpression(expression->lhs, TypeBool);
	resolveExpression(expression->rhs, TypeBool);
	return TypeBool;
};

func resolveExpressionPrefix(expression: ExpressionPrefix*, expectedType: Type*): Type* {
	if (expression->operator->kind == .Not) {
		if (expectedType != NULL && expectedType != TypeBool) {
			ResolverError(expression->operator->pos, "not expecting boolean result from logical not", "", "");
		};
		resolveExpression(expression->expression, TypeBool);
		return TypeBool;
	} else {
		ProgrammingError("called resolveExpressionPrefix on a .Invalid");
		return NULL;
	};
};

func resolveExpressionInfix(expression: ExpressionInfix*, expectedType: Type*): Type* {
	if (expression->operator->kind == .Equal) {
		return resolveExpressionInfixComparison(expression, expectedType);
	} else if (expression->operator->kind == .NotEqual) {
		return resolveExpressionInfixComparison(expression, expectedType);
	} else if (expression->operator->kind == .LessThan) {
		return resolveExpressionInfixComparison(expression, expectedType);
	} else if (expression->operator->kind == .GreaterThan) {
		return resolveExpressionInfixComparison(expression, expectedType);
	} else if (expression->operator->kind == .LessThanEqual) {
		return resolveExpressionInfixComparison(expression, expectedType);
	} else if (expression->operator->kind == .GreaterThanEqual) {
		return resolveExpressionInfixComparison(expression, expectedType);
	} else if (expression->operator->kind == .Plus) {
		return resolveExpressionInfixAddition(expression, expectedType);
	} else if (expression->operator->kind == .Minus) {
		return resolveExpressionInfixAddition(expression, expectedType);
	} else if (expression->operator->kind == .Star) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else if (expression->operator->kind == .Slash) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else if (expression->operator->kind == .And) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else if (expression->operator->kind == .AndAnd) {
		return resolveExpressionInfixLogical(expression, expectedType);
	} else if (expression->operator->kind == .Or) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else if (expression->operator->kind == .OrOr) {
		return resolveExpressionInfixLogical(expression, expectedType);
	} else if (expression->operator->kind == .Xor) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else if (expression->operator->kind == .LeftShift) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else if (expression->operator->kind == .RightShift) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else {
		ProgrammingError("called resolveExpressionInfix on a .Invalid");
		return NULL;
	};;;;;;;;;;;;;;;;;
};

func resolveExpressionTernary(expression: ExpressionTernary*, expectedType: Type*): Type* {
	resolveExpression(expression->condition, TypeBool);
	var type = resolveExpression(expression->positive, expectedType);
	return resolveExpression(expression->negative, type);
};

func resolveExpressionIdentifier(expression: ExpressionIdentifier*, expectedType: Type*): Type* {
	var symbol = resolveSymbol(expression->identifier->string);
	if (symbol == NULL) {
		ResolverError(expression->identifier->pos, "identifier '", expression->identifier->string->string, "' is not a variable or function");
	};
	if (expectedType != NULL && expectedType != symbol->type) {
		ResolverError(expression->identifier->pos, "identifier '", expression->identifier->string->string, "' is the wrong type");
	};
	return symbol->type;
};

func resolveExpressionBooleanLiteral(expression: ExpressionBooleanLiteral*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeBool) {
		ResolverError(expression->literal->pos, "wrong type (got boolean literal)", "", "");
	};
	return TypeBool;
};

func resolveExpressionIntegerLiteral(expression: ExpressionIntegerLiteral*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeUInt) {
		ResolverError(expression->literal->pos, "wrong type (got integer literal)", "", "");
	};
	return TypeUInt;
};

func resolveExpressionCharacterLiteral(expression: ExpressionCharacterLiteral*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeCharacter) {
		ResolverError(expression->literal->pos, "wrong type (got character literal)", "", "");
	};
	return TypeCharacter;
};

func resolveExpressionStringLiteral(expression: ExpressionStringLiteral*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeString) {
		ResolverError(expression->literal->pos, "wrong type (got string literal)", "", "");
	};
	return TypeString;
};

func resolveExpression(expression: Expression*, expectedType: Type*): Type* {
	if (expression->kind == .Group) {
		expression->resolvedType = resolveExpression((Expression*)expression->expression, expectedType);
	} else if (expression->kind == .Cast) {
		expression->resolvedType = resolveExpressionCast((ExpressionCast*)expression->expression, expectedType);
	} else if (expression->kind == .Sizeof) {
		expression->resolvedType = resolveExpressionSizeof((ExpressionSizeof*)expression->expression, expectedType);
	} else if (expression->kind == .Offsetof) {
		expression->resolvedType = resolveExpressionOffsetof((ExpressionOffsetof*)expression->expression, expectedType);
	} else if (expression->kind == .Dereference) {
		expression->resolvedType = resolveExpressionDereference((ExpressionDereference*)expression->expression, expectedType);
	} else if (expression->kind == .Reference) {
		expression->resolvedType = resolveExpressionReference((ExpressionReference*)expression->expression, expectedType);
	} else if (expression->kind == .FunctionCall) {
		expression->resolvedType = resolveExpressionFunctionCall((ExpressionFunctionCall*)expression->expression, expectedType);
	} else if (expression->kind == .Subscript) {
		expression->resolvedType = resolveExpressionSubscript((ExpressionSubscript*)expression->expression, expectedType);
	} else if (expression->kind == .Arrow) {
		expression->resolvedType = resolveExpressionArrow((ExpressionArrow*)expression->expression, expectedType);
	} else if (expression->kind == .Dot) {
		expression->resolvedType = resolveExpressionDot((ExpressionDot*)expression->expression, expectedType);
	} else if (expression->kind == .PrefixOperator) {
		expression->resolvedType = resolveExpressionPrefix((ExpressionPrefix*)expression->expression, expectedType);
	} else if (expression->kind == .InfixOperator) {
		expression->resolvedType = resolveExpressionInfix((ExpressionInfix*)expression->expression, expectedType);
	} else if (expression->kind == .Ternary) {
		expression->resolvedType = resolveExpressionTernary((ExpressionTernary*)expression->expression, expectedType);
	} else if (expression->kind == .Identifier) {
		expression->resolvedType = resolveExpressionIdentifier((ExpressionIdentifier*)expression->expression, expectedType);
	} else if (expression->kind == .Null) {
		expression->resolvedType = TypeAny;
	} else if (expression->kind == .BooleanLiteral) {
		expression->resolvedType = resolveExpressionBooleanLiteral((ExpressionBooleanLiteral*)expression->expression, expectedType);
	} else if (expression->kind == .IntegerLiteral) {
		expression->resolvedType = resolveExpressionIntegerLiteral((ExpressionIntegerLiteral*)expression->expression, expectedType);
	} else if (expression->kind == .CharacterLiteral) {
		expression->resolvedType = resolveExpressionCharacterLiteral((ExpressionCharacterLiteral*)expression->expression, expectedType);
	} else if (expression->kind == .StringLiteral) {
		expression->resolvedType = resolveExpressionStringLiteral((ExpressionStringLiteral*)expression->expression, expectedType);
	} else {
		ProgrammingError("called resolveExpression on a .Invalid");
	};;;;;;;;;;;;;;;;;;;
	if (expression->resolvedType == NULL) {
		ProgrammingError("expression missing resolvedType");
	};
	return expression->resolvedType;
};
