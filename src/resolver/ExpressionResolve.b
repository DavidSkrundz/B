func resolveExpressionCast(expression: ExpressionCast*, expectedType: Type*): Type* {
	resolveExpression(expression->expression, NULL);
	var castType = resolveTypespec(expression->type);
	if (castType == NULL) {
		abort();
	};
	if (expectedType != NULL && expectedType != castType) {
		fprintf(stderr, (char*)"Cast to wrong type%c", 10);
		exit(EXIT_FAILURE);
	};
	return castType;
};

func resolveExpressionSizeof(expression: ExpressionSizeof*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeUInt) {
		fprintf(stderr, (char*)"Not expecting UInt%c", 10);
		exit(EXIT_FAILURE);
	};
	expression->resolvedType = resolveTypespec(expression->type);
	return TypeUInt;
};

func resolveExpressionDereference(expression: ExpressionDereference*, expectedType: Type*): Type* {
	var expectedBaseType: Type*;
	if (expectedType != NULL) {
		expectedBaseType = resolveTypePointer(expectedType);
		if (expectedBaseType == NULL) {
			expectedBaseType = createTypePointer(expectedType);
		};
	};
	var baseType = resolveExpression(expression->expression, expectedBaseType);
	if (isPointer(baseType) == false) {
		fprintf(stderr, (char*)"Cannot dereference non-pointer%c", 10);
		exit(EXIT_FAILURE);
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
	if (functionType->kind != TypeKind_Function) {
		fprintf(stderr, (char*)"Can't call non-function%c", 10);
		exit(EXIT_FAILURE);
	};
	var funcType = (TypeFunction*)functionType->type;
	if (expectedType != NULL && expectedType != funcType->returnType) {
		fprintf(stderr, (char*)"Function returns wrong type%c", 10);
		exit(EXIT_FAILURE);
	};
	
	if (expression->count < funcType->count) {
		fprintf(stderr, (char*)"Not enough arguments in function call%c", 10);
		exit(EXIT_FAILURE);
	};
	if (funcType->count < expression->count && funcType->isVariadic == false) {
		fprintf(stderr, (char*)"Too many arguments in function call%c", 10);
		exit(EXIT_FAILURE);
	};
	var i = 0;
	while (i < funcType->count) {
		resolveExpression(expression->arguments[i], funcType->argumentTypes[i]);
		i = i + 1;
	};
	i = 0;
	while (i < expression->count) {
		resolveExpression(expression->arguments[i], NULL);
		i = i + 1;
	};
	
	return funcType->returnType;
};

func resolveExpressionSubscript(expression: ExpressionSubscript*, expectedType: Type*): Type* {
	var expectedBaseType: Type*;
	if (expectedType != NULL) {
		expectedBaseType = resolveTypePointer(expectedType);
		if (expectedBaseType == NULL) {
			expectedBaseType = createTypePointer(expectedType);
		};
	};
	var baseType = resolveExpression(expression->base, expectedBaseType);
	if (isPointer(baseType) == false) {
		fprintf(stderr, (char*)"Cannot subscript non-pointer%c", 10);
		exit(EXIT_FAILURE);
	};
	resolveExpression(expression->subscript, TypeUInt);
	return getPointerBase(baseType);
};

func resolveExpressionArrow(expression: ExpressionArrow*, expectedType: Type*): Type* {
	var pointerType = resolveExpression(expression->base, NULL);
	var baseType = getPointerBase(pointerType);
	var structDeclaration: DeclarationStruct*;
	var i = 0;
	while (i < _declarationCount) {
		if (_declarations[i]->kind == DeclarationKind_Struct) {
			if (_declarations[i]->resolvedType == baseType) {
				structDeclaration = (DeclarationStruct*)_declarations[i]->declaration;
			};
		};
		i = i + 1;
	};
	if (structDeclaration == NULL) {
		fprintf(stderr, (char*)"Can't apply -> to non-struct%c", 10);
		exit(EXIT_FAILURE);
	};
	i = 0;
	while (i < structDeclaration->fields->count) {
		var name = structDeclaration->fields->fields[i]->name;
		if (name->length == expression->field->length) {
			if (strncmp((char*)name->name, (char*)expression->field->name, name->length) == (int)0) {
				if (expectedType != NULL && expectedType != structDeclaration->fields->fields[i]->resolvedType) {
					fprintf(stderr, (char*)"Struct field has wrong type: %.*s%c", (int)name->length, (char*)name->name, 10);
					exit(EXIT_FAILURE);
				};
				return structDeclaration->fields->fields[i]->resolvedType;
			};
		};
		i = i + 1;
	};
	fprintf(stderr, (char*)"Struct field does not exist%c", 10);
	exit(EXIT_FAILURE);
};

func resolveExpressionInfixComparison(expression: ExpressionInfix*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeBool) {
		fprintf(stderr, (char*)"Not expecting bool from comparison%c", 10);
		exit(EXIT_FAILURE);
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
		fprintf(stderr, (char*)"Not expecting bool from logical%c", 10);
		exit(EXIT_FAILURE);
	};
	resolveExpression(expression->lhs, TypeBool);
	resolveExpression(expression->rhs, TypeBool);
	return TypeBool;
};

func resolveExpressionInfix(expression: ExpressionInfix*, expectedType: Type*): Type* {
	if (expression->operator->kind == TokenKind_Equal) {
		return resolveExpressionInfixComparison(expression, expectedType);
	} else if (expression->operator->kind == TokenKind_NotEqual) {
		return resolveExpressionInfixComparison(expression, expectedType);
	} else if (expression->operator->kind == TokenKind_LessThan) {
		return resolveExpressionInfixComparison(expression, expectedType);
	} else if (expression->operator->kind == TokenKind_Plus) {
		return resolveExpressionInfixAddition(expression, expectedType);
	} else if (expression->operator->kind == TokenKind_Minus) {
		return resolveExpressionInfixAddition(expression, expectedType);
	} else if (expression->operator->kind == TokenKind_Star) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else if (expression->operator->kind == TokenKind_Slash) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else if (expression->operator->kind == TokenKind_And) {
		return resolveExpressionInfixMultiplication(expression, expectedType);
	} else if (expression->operator->kind == TokenKind_AndAnd) {
		return resolveExpressionInfixLogical(expression, expectedType);
	} else if (expression->operator->kind == TokenKind_OrOr) {
		return resolveExpressionInfixLogical(expression, expectedType);
	} else {
		fprintf(stderr, (char*)"Invalid operator %zu%c", expression->operator->kind, 10);
		abort();
	};;;;;;;;;;
};

func resolveExpressionIdentifier(expression: ExpressionIdentifier*, expectedType: Type*): Type* {
	var i = 0;
	while (i < _context->count) {
		if (_context->names[i]->length == expression->identifier->length) {
			if (strncmp((char*)_context->names[i]->name, (char*)expression->identifier->name, expression->identifier->length) == (int)0) {
				if (expectedType != NULL && expectedType != _context->types[i]) {
					fprintf(stderr, (char*)"Identifier is wrong type: %.*s%c", (int)expression->identifier->length, (char*)expression->identifier->name, 10);
					exit(EXIT_FAILURE);
				};
				return _context->types[i];
			};
		};
		i = i + 1;
	};
	fprintf(stderr, (char*)"Identifier is not a variable or function: %.*s%c", (int)expression->identifier->length, (char*)expression->identifier->name, 10);
	exit(EXIT_FAILURE);
};

func resolveExpressionBooleanLiteral(expression: ExpressionBooleanLiteral*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeBool) {
		fprintf(stderr, (char*)"Not expecting bool%c", 10);
		exit(EXIT_FAILURE);
	};
	return TypeBool;
};

func resolveExpressionIntegerLiteral(expression: ExpressionIntegerLiteral*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeUInt) {
		fprintf(stderr, (char*)"Not expecting Int%c", 10);
		exit(EXIT_FAILURE);
	};
	return TypeUInt;
};

func resolveExpressionStringLiteral(expression: ExpressionStringLiteral*, expectedType: Type*): Type* {
	if (expectedType != NULL && expectedType != TypeString) {
		fprintf(stderr, (char*)"Not expecting string (pointer UInt8)%c", 10);
		exit(EXIT_FAILURE);
	};
	return TypeString;
};

func resolveExpression(expression: Expression*, expectedType: Type*): Type* {
	if (expression->kind == ExpressionKind_Group) {
		expression->resolvedType = resolveExpression((Expression*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Cast) {
		expression->resolvedType = resolveExpressionCast((ExpressionCast*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Sizeof) {
		expression->resolvedType = resolveExpressionSizeof((ExpressionSizeof*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Dereference) {
		expression->resolvedType = resolveExpressionDereference((ExpressionDereference*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Reference) {
		expression->resolvedType = resolveExpressionReference((ExpressionReference*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_FunctionCall) {
		expression->resolvedType = resolveExpressionFunctionCall((ExpressionFunctionCall*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Subscript) {
		expression->resolvedType = resolveExpressionSubscript((ExpressionSubscript*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Arrow) {
		expression->resolvedType = resolveExpressionArrow((ExpressionArrow*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_InfixOperator) {
		expression->resolvedType = resolveExpressionInfix((ExpressionInfix*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Identifier) {
		expression->resolvedType = resolveExpressionIdentifier((ExpressionIdentifier*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_NULL) {
		expression->resolvedType = TypeAny;
	} else if (expression->kind == ExpressionKind_BooleanLiteral) {
		expression->resolvedType = resolveExpressionBooleanLiteral((ExpressionBooleanLiteral*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_IntegerLiteral) {
		expression->resolvedType = resolveExpressionIntegerLiteral((ExpressionIntegerLiteral*)expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_StringLiteral) {
		expression->resolvedType = resolveExpressionStringLiteral((ExpressionStringLiteral*)expression->expression, expectedType);
	} else {
		fprintf(stderr, (char*)"Invalid expression kind %zu%c", expression->kind, 10);
		abort();
	};;;;;;;;;;;;;;
	if (expression->resolvedType == NULL) {
		abort();
	};
	return expression->resolvedType;
};
