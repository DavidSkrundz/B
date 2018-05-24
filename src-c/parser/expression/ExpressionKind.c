#include "ExpressionKind.h"

int ExpressionKind_Invalid;
int ExpressionKind_Group;
int ExpressionKind_Cast;
int ExpressionKind_Sizeof;
int ExpressionKind_Dereference;
int ExpressionKind_Reference;
int ExpressionKind_FunctionCall;
int ExpressionKind_Subscript;
int ExpressionKind_Arrow;
int ExpressionKind_InfixOperator;
int ExpressionKind_Identifier;
int ExpressionKind_NULL;
int ExpressionKind_BooleanLiteral;
int ExpressionKind_IntegerLiteral;
int ExpressionKind_StringLiteral;

void InitExpressionKinds(void) {
	int counter = 0;
	
	ExpressionKind_Invalid = counter++;
	ExpressionKind_Group = counter++;
	ExpressionKind_Cast = counter++;
	ExpressionKind_Sizeof = counter++;
	ExpressionKind_Dereference = counter++;
	ExpressionKind_Reference = counter++;
	ExpressionKind_FunctionCall = counter++;
	ExpressionKind_Subscript = counter++;
	ExpressionKind_Arrow = counter++;
	ExpressionKind_InfixOperator = counter++;
	ExpressionKind_Identifier = counter++;
	ExpressionKind_NULL = counter++;
	ExpressionKind_BooleanLiteral = counter++;
	ExpressionKind_IntegerLiteral = counter++;
	ExpressionKind_StringLiteral = counter++;
}
