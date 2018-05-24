#include "ExpressionResolve.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../lexer/token/TokenKind.h"
#include "../parser/Parser.h"
#include "../parser/declaration/DeclarationKind.h"
#include "../parser/expression/ExpressionKind.h"
#include "Context.h"
#include "type/TypeBuiltin.h"
#include "type/TypeKind.h"
#include "type/TypeResolve.h"
#include "TypespecResolve.h"
#include "DeclarationResolve.h"

extern Context* context;

Type* resolveExpressionCast(ExpressionCast* expression, Type* expectedType) {
	resolveExpression(expression->expression, NULL);
	Type* castType = resolveTypespec(expression->type);
	if (castType == NULL) {
		abort();
	}
	if (expectedType != NULL && expectedType != castType) {
		fprintf(stderr, "Cast to wrong type\n");
		exit(EXIT_FAILURE);
	}
	return castType;
}

Type* resolveExpressionSizeof(ExpressionSizeof* expression, Type* expectedType) {
	if (expectedType != NULL && expectedType != TypeUInt) {
		fprintf(stderr, "Not expecting UInt\n");
		exit(EXIT_FAILURE);
	}
	expression->resolvedType = resolveTypespec(expression->type);
	return TypeUInt;
}

Type* resolveExpressionDereference(ExpressionDereference* expression, Type* expectedType) {
	Type* expectedBaseType = NULL;
	if (expectedType != NULL) {
		expectedBaseType = resolveTypePointer(expectedType);
		if (expectedBaseType == NULL) {
			expectedBaseType = createTypePointer(expectedType);
		}
	}
	Type* baseType = resolveExpression(expression->expression, expectedBaseType);
	if (!isPointer(baseType)) {
		fprintf(stderr, "Cannot dereference non-pointer\n");
		exit(EXIT_FAILURE);
	}
	return getPointerBase(baseType);
}

Type* resolveExpressionReference(ExpressionReference* expression, Type* expectedType) {
	Type* expectedPointerType = NULL;
	if (expectedType != NULL) {
		expectedPointerType = getPointerBase(expectedType);
	}
	Type* type = resolveExpression(expression->expression, expectedPointerType);
	return resolveTypePointer(type);
}

Type* resolveExpressionFunctionCall(ExpressionFunctionCall* expression, Type* expectedType) {
	Type* functionType = resolveExpression(expression->function, NULL);
	if (functionType->kind != TypeKind_Function) {
		fprintf(stderr, "Can't call non-function\n");
		exit(EXIT_FAILURE);
	}
	TypeFunction* funcType = functionType->type;
	if (expectedType != NULL && expectedType != funcType->returnType) {
		fprintf(stderr, "Function returns wrong type\n");
		exit(EXIT_FAILURE);
	}
	
	if (funcType->count > expression->count) {
		fprintf(stderr, "Not enough arguments in function call\n");
		exit(EXIT_FAILURE);
	}
	if (funcType->count < expression->count && !funcType->isVariadic) {
		fprintf(stderr, "Too many arguments in function call\n");
		exit(EXIT_FAILURE);
	}
	for (int i = 0; i < funcType->count; ++i) {
		resolveExpression(expression->arguments[i], funcType->argumentTypes[i]);
	}
	for (int i = funcType->count; i < expression->count; ++i) {
		resolveExpression(expression->arguments[i], NULL);
	}
	
	return funcType->returnType;
}

Type* resolveExpressionSubscript(ExpressionSubscript* expression, Type* expectedType) {
	Type* expectedBaseType = NULL;
	if (expectedType != NULL) {
		expectedBaseType = resolveTypePointer(expectedType);
		if (expectedBaseType == NULL) {
			expectedBaseType = createTypePointer(expectedType);
		}
	}
	Type* baseType = resolveExpression(expression->base, expectedBaseType);
	if (!isPointer(baseType)) {
		fprintf(stderr, "Cannot subscript non-pointer\n");
		exit(EXIT_FAILURE);
	}
	resolveExpression(expression->subscript, TypeUInt);
	return getPointerBase(baseType);
}

Type* resolveExpressionArrow(ExpressionArrow* expression, Type* expectedType) {
	Type* pointerType = resolveExpression(expression->base, NULL);
	Type* baseType = getPointerBase(pointerType);
	DeclarationStruct* structDeclaration = NULL;
	for (int i = 0; i < declarationCount; ++i) {
		if (declarations[i]->kind == DeclarationKind_Struct) {
			if (declarations[i]->resolvedType == baseType) {
				structDeclaration = declarations[i]->declaration;
			}
		}
	}
	if (structDeclaration == NULL) {
		fprintf(stderr, "Can't apply -> to non-struct\n");
		exit(EXIT_FAILURE);
	}
	for (int i = 0; i < structDeclaration->fields->count; ++i) {
		Identifier* name = structDeclaration->fields->fields[i]->name;
		if (name->length != expression->field->length) { continue; }
		if (strncmp(name->name, expression->field->name, name->length) != 0) { continue; }
		if (expectedType != NULL && expectedType != structDeclaration->fields->fields[i]->resolvedType) {
			fprintf(stderr, "Struct field has wrong type: %.*s\n", name->length, name->name);
			exit(EXIT_FAILURE);
		}
		return structDeclaration->fields->fields[i]->resolvedType;
	}
	fprintf(stderr, "Struct field does not exist\n");
	exit(EXIT_FAILURE);
}

Type* resolveExpressionInfixComparison(ExpressionInfix* expression, Type* expectedType) {
	if (expectedType != NULL && expectedType != TypeBool) {
		fprintf(stderr, "Not expecting bool from comparison\n");
		exit(EXIT_FAILURE);
	}
	Type* lhs = resolveExpression(expression->lhs, NULL);
	resolveExpression(expression->rhs, lhs);
	return TypeBool;
}

Type* resolveExpressionInfixAddition(ExpressionInfix* expression, Type* expectedType) {
	Type* lhs = resolveExpression(expression->lhs, expectedType);
	Type* rhs = resolveExpression(expression->rhs, lhs);
	return rhs;
}

Type* resolveExpressionInfixMultiplication(ExpressionInfix* expression, Type* expectedType) {
	Type* lhs = resolveExpression(expression->lhs, expectedType);
	Type* rhs = resolveExpression(expression->rhs, lhs);
	return rhs;
}

Type* resolveExpressionInfixLogical(ExpressionInfix* expression, Type* expectedType) {
	if (expectedType != NULL && expectedType != TypeBool) {
		fprintf(stderr, "Not expecting bool from logical\n");
		exit(EXIT_FAILURE);
	}
	resolveExpression(expression->lhs, TypeBool);
	resolveExpression(expression->rhs, TypeBool);
	return TypeBool;
}

Type* resolveExpressionInfix(ExpressionInfix* expression, Type* expectedType) {
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
		fprintf(stderr, "Invalid operator %d\n", expression->operator->kind);
		abort();
	}
}

Type* resolveExpressionIdentifier(ExpressionIdentifier* expression, Type* expectedType) {
	for (int i = 0; i < context->count; ++i) {
		if (context->names[i]->length != expression->identifier->length) { continue; }
		if (strncmp(context->names[i]->name, expression->identifier->name, expression->identifier->length) != 0) { continue; }
		if (expectedType != NULL && expectedType != context->types[i]) {
			fprintf(stderr, "Identifier is wrong type: %.*s\n", expression->identifier->length, expression->identifier->name);
			exit(EXIT_FAILURE);
		}
		return context->types[i];
	}
	fprintf(stderr, "Identifier is not a variable or function: %.*s\n", expression->identifier->length, expression->identifier->name);
	exit(EXIT_FAILURE);
}

Type* resolveExpressionBooleanLiteral(ExpressionBooleanLiteral* expression, Type* expectedType) {
	if (expectedType != NULL && expectedType != TypeBool) {
		fprintf(stderr, "Not expecting bool\n");
		exit(EXIT_FAILURE);
	}
	return TypeBool;
}

Type* resolveExpressionIntegerLiteral(ExpressionIntegerLiteral* expression, Type* expectedType) {
	if (expectedType != NULL && expectedType != TypeInt) {
		fprintf(stderr, "Not expecting Int\n");
		exit(EXIT_FAILURE);
	}
	return TypeInt;
}

Type* resolveExpressionStringLiteral(ExpressionStringLiteral* expression, Type* expectedType) {
	if (expectedType != NULL && expectedType != TypeString) {
		fprintf(stderr, "Not expecting string (pointer UInt8)\n");
		exit(EXIT_FAILURE);
	}
	return TypeString;
}

Type* resolveExpression(Expression* expression, Type* expectedType) {
	if (expression->kind == ExpressionKind_Group) {
		expression->resolvedType = resolveExpression(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Cast) {
		expression->resolvedType = resolveExpressionCast(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Sizeof) {
		expression->resolvedType = resolveExpressionSizeof(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Dereference) {
		expression->resolvedType = resolveExpressionDereference(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Reference) {
		expression->resolvedType = resolveExpressionReference(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_FunctionCall) {
		expression->resolvedType = resolveExpressionFunctionCall(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Subscript) {
		expression->resolvedType = resolveExpressionSubscript(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Arrow) {
		expression->resolvedType = resolveExpressionArrow(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_InfixOperator) {
		expression->resolvedType = resolveExpressionInfix(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_Identifier) {
		expression->resolvedType = resolveExpressionIdentifier(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_NULL) {
		expression->resolvedType = TypeAny;
	} else if (expression->kind == ExpressionKind_BooleanLiteral) {
		expression->resolvedType = resolveExpressionBooleanLiteral(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_IntegerLiteral) {
		expression->resolvedType = resolveExpressionIntegerLiteral(expression->expression, expectedType);
	} else if (expression->kind == ExpressionKind_StringLiteral) {
		expression->resolvedType = resolveExpressionStringLiteral(expression->expression, expectedType);
	} else {
		fprintf(stderr, "Invalid expression kind %d\n", expression->kind);
		abort();
	}
	if (expression->resolvedType == NULL) {
		abort();
	}
	return expression->resolvedType;
}
