#include "ExpressionParse.h"

#include <stdio.h>
#include <stdlib.h>

#include "../../lexer/token/TokenKind.h"
#include "ExpressionKind.h"
#include "../typespec/TypespecParse.h"
#include "../../utility/Memory.h"
#include "../identifier/IdentifierParse.h"

Expression* parseExpressionPrimary(Token*** tokens) {
	Expression* expression = newExpression();
	if ((**tokens)->kind == TokenKind_OpenParenthesis) {
		++(*tokens);
		expression->kind = ExpressionKind_Group;
		expression->expression = parseExpression(tokens);
		if ((**tokens)->kind != TokenKind_CloseParenthesis) { return NULL; }
		++(*tokens);
	} else if ((**tokens)->kind == TokenKind_Identifier) {
		expression->kind = ExpressionKind_Identifier;
		ExpressionIdentifier* identifier = newExpressionIdentifier();
		identifier->identifier = parseIdentifier(tokens);
		expression->expression = identifier;
	} else if ((**tokens)->kind == TokenKind_NULL) {
		++(*tokens);
		expression->kind = ExpressionKind_NULL;
	} else if ((**tokens)->kind == TokenKind_BooleanLiteral) {
		expression->kind = ExpressionKind_BooleanLiteral;
		ExpressionBooleanLiteral* literal = newExpressionBooleanLiteral();
		literal->literal = *((*tokens)++);
		expression->expression = literal;
	} else if ((**tokens)->kind == TokenKind_IntegerLiteral) {
		expression->kind = ExpressionKind_IntegerLiteral;
		ExpressionIntegerLiteral* literal = newExpressionIntegerLiteral();
		literal->literal = *((*tokens)++);
		expression->expression = literal;
	} else if ((**tokens)->kind == TokenKind_StringLiteral) {
		expression->kind = ExpressionKind_StringLiteral;
		ExpressionStringLiteral* literal = newExpressionStringLiteral();
		literal->literal = *((*tokens)++);
		expression->expression = literal;
	} else { return NULL; }
	return expression;
}

extern int MAX_FUNC_ARGUMENT_COUNT;
ExpressionFunctionCall* parseExpressionFunctionCallArguments(Token*** tokens) {
	ExpressionFunctionCall* expression = newExpressionFunctionCall();
	if ((**tokens)->kind != TokenKind_OpenParenthesis) { return NULL; }
	++(*tokens);
	expression->arguments = xcalloc(MAX_FUNC_ARGUMENT_COUNT, sizeof(Expression*));
	expression->count = 0;
	while ((**tokens)->kind != TokenKind_CloseParenthesis) {
		if (expression->count >= MAX_FUNC_ARGUMENT_COUNT) {
			fprintf(stderr, "Too many arguments in function call\n");
			exit(EXIT_FAILURE);
		}
		Expression* argument = parseExpression(tokens);
		if (argument == NULL) { return NULL; }
		expression->arguments[expression->count++] = argument;
		if ((**tokens)->kind != TokenKind_Comma) { break; }
		++(*tokens);
	}
	++(*tokens);
	return expression;
}

ExpressionSubscript* parseExpressionSubscript(Token*** tokens) {
	ExpressionSubscript* expression = newExpressionSubscript();
	if ((**tokens)->kind != TokenKind_OpenBracket) { return NULL; }
	++(*tokens);
	expression->subscript = parseExpression(tokens);
	if (expression->subscript == NULL) { return NULL; }
	if ((**tokens)->kind != TokenKind_CloseBracket) { return NULL; }
	++(*tokens);
	return expression;
}

ExpressionArrow* parseExpressionArrow(Token*** tokens) {
	ExpressionArrow* expression = newExpressionArrow();
	if ((**tokens)->kind != TokenKind_Arrow) { return NULL; }
	++(*tokens);
	expression->field = parseIdentifier(tokens);
	if (expression->field == NULL) { return NULL; }
	return expression;
}

Expression* parseExpressionPostfix(Token*** tokens) {
	Expression* expression = parseExpressionPrimary(tokens);
	if (expression == NULL) { return NULL; }
	while (true) {
		if ((**tokens)->kind == TokenKind_OpenParenthesis) {
			ExpressionFunctionCall* func = parseExpressionFunctionCallArguments(tokens);
			if (func == NULL) { return NULL; }
			func->function = expression;
			expression = newExpression();
			expression->kind = ExpressionKind_FunctionCall;
			expression->expression = func;
		} else if ((**tokens)->kind == TokenKind_OpenBracket) {
			ExpressionSubscript* subscript = parseExpressionSubscript(tokens);
			if (subscript == NULL) { return NULL; }
			subscript->base = expression;
			expression = newExpression();
			expression->kind = ExpressionKind_Subscript;
			expression->expression = subscript;
		} else if ((**tokens)->kind == TokenKind_Arrow) {
			ExpressionArrow* arrow = parseExpressionArrow(tokens);
			if (arrow == NULL) { return NULL; }
			arrow->base = expression;
			expression = newExpression();
			expression->kind = ExpressionKind_Arrow;
			expression->expression = arrow;
		} else { break; }
	}
	return expression;
}

Expression* parseExpressionCast(Token*** tokens);
Expression* parseExpressionUnary(Token*** tokens) {
	if ((**tokens)->kind == TokenKind_Sizeof) {
		++(*tokens);
		if ((**tokens)->kind != TokenKind_OpenParenthesis) { return NULL; }
		++(*tokens);
		ExpressionSizeof* expr = newExpressionSizeof();
		expr->type = parseTypespec(tokens);
		if (expr->type == NULL) { return NULL; }
		if ((**tokens)->kind != TokenKind_CloseParenthesis) { return NULL; }
		++(*tokens);
		Expression* expression = newExpression();
		expression->kind = ExpressionKind_Sizeof;
		expression->expression = expr;
		return expression;
	} else if ((**tokens)->kind == TokenKind_Star) {
		++(*tokens);
		ExpressionDereference* expr = newExpressionDereference();
		expr->expression = parseExpressionCast(tokens);
		if (expr->expression == NULL) { return NULL; }
		Expression* expression = newExpression();
		expression->kind = ExpressionKind_Dereference;
		expression->expression = expr;
		return expression;
	} else if ((**tokens)->kind == TokenKind_And) {
		++(*tokens);
		ExpressionReference* expr = newExpressionReference();
		expr->expression = parseExpressionCast(tokens);
		if (expr->expression == NULL) { return NULL; }
		Expression* expression = newExpression();
		expression->kind = ExpressionKind_Reference;
		expression->expression = expr;
		return expression;
	} else {
		return parseExpressionPostfix(tokens);
	}
}

Expression* parseExpressionCast(Token*** tokens) {
	Token** save = *tokens;
	if ((**tokens)->kind == TokenKind_OpenParenthesis) {
		++(*tokens);
		Expression* expression = newExpression();
		expression->kind = ExpressionKind_Cast;
		ExpressionCast* expressionCast = newExpressionCast();
		expression->expression = expressionCast;
		expressionCast->type = parseTypespec(tokens);
		if (expressionCast->type == NULL) {
			*tokens = save;
			return parseExpressionUnary(tokens);
		}
		if ((**tokens)->kind != TokenKind_CloseParenthesis) {
			*tokens = save;
			return parseExpressionUnary(tokens);
		}
		++(*tokens);
		expressionCast->expression = parseExpressionCast(tokens);
		if (expressionCast->expression == NULL) { return NULL; }
		return expression;
	} else {
		return parseExpressionUnary(tokens);
	}
}

Expression* parseExpressionMultiplicative(Token*** tokens) {
	Expression* expression = parseExpressionCast(tokens);
	if (expression == NULL) { return NULL; }
	while (true) {
		ExpressionInfix* infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_Star) {
			infix->operator = **tokens;
			++(*tokens);
		} else if ((**tokens)->kind == TokenKind_Slash) {
			infix->operator = **tokens;
			++(*tokens);
		} else if ((**tokens)->kind == TokenKind_And) {
			infix->operator = **tokens;
			++(*tokens);
		} else { break; }
		infix->lhs = expression;
		infix->rhs = parseExpressionCast(tokens);
		if (infix->rhs == NULL) { return NULL; }
		expression = newExpression();
		expression->kind = ExpressionKind_InfixOperator;
		expression->expression = infix;
	}
	return expression;
}

Expression* parseExpressionAdditive(Token*** tokens) {
	Expression* expression = parseExpressionMultiplicative(tokens);
	if (expression == NULL) { return NULL; }
	while (true) {
		ExpressionInfix* infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_Plus) {
			infix->operator = **tokens;
			++(*tokens);
		} else if ((**tokens)->kind == TokenKind_Minus) {
			infix->operator = **tokens;
			++(*tokens);
		} else { break; }
		infix->lhs = expression;
		infix->rhs = parseExpressionMultiplicative(tokens);
		if (infix->rhs == NULL) { return NULL; }
		expression = newExpression();
		expression->kind = ExpressionKind_InfixOperator;
		expression->expression = infix;
	}
	return expression;
}

Expression* parseExpressionComparison(Token*** tokens) {
	Expression* expression = parseExpressionAdditive(tokens);
	if (expression == NULL) { return NULL; }
	while (true) {
		ExpressionInfix* infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_LessThan) {
			infix->operator = **tokens;
			++(*tokens);
		} else { break; }
		infix->lhs = expression;
		infix->rhs = parseExpressionAdditive(tokens);
		if (infix->rhs == NULL) { return NULL; }
		expression = newExpression();
		expression->kind = ExpressionKind_InfixOperator;
		expression->expression = infix;
	}
	return expression;
}

Expression* parseExpressionEquality(Token*** tokens) {
	Expression* expression = parseExpressionComparison(tokens);
	if (expression == NULL) { return NULL; }
	while (true) {
		ExpressionInfix* infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_Equal) {
			infix->operator = **tokens;
			++(*tokens);
		} else if ((**tokens)->kind == TokenKind_NotEqual) {
			infix->operator = **tokens;
			++(*tokens);
		} else { break; }
		infix->lhs = expression;
		infix->rhs = parseExpressionComparison(tokens);
		if (infix->rhs == NULL) { return NULL; }
		expression = newExpression();
		expression->kind = ExpressionKind_InfixOperator;
		expression->expression = infix;
	}
	return expression;
}

Expression* parseExpressionLogicalAND(Token*** tokens) {
	Expression* expression = parseExpressionEquality(tokens);
	if (expression == NULL) { return NULL; }
	while (true) {
		ExpressionInfix* infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_AndAnd) {
			infix->operator = **tokens;
			++(*tokens);
		} else { break; }
		infix->lhs = expression;
		infix->rhs = parseExpressionEquality(tokens);
		if (infix->rhs == NULL) { return NULL; }
		expression = newExpression();
		expression->kind = ExpressionKind_InfixOperator;
		expression->expression = infix;
	}
	return expression;
}

Expression* parseExpressionLogicalOR(Token*** tokens) {
	Expression* expression = parseExpressionLogicalAND(tokens);
	if (expression == NULL) { return NULL; }
	while (true) {
		ExpressionInfix* infix = newExpressionInfixOperator();
		if ((**tokens)->kind == TokenKind_OrOr) {
			infix->operator = **tokens;
			++(*tokens);
		} else { break; }
		infix->lhs = expression;
		infix->rhs = parseExpressionLogicalAND(tokens);
		if (infix->rhs == NULL) { return NULL; }
		expression = newExpression();
		expression->kind = ExpressionKind_InfixOperator;
		expression->expression = infix;
	}
	return expression;
}

Expression* parseExpression(Token*** tokens) {
	return parseExpressionLogicalOR(tokens);
}
