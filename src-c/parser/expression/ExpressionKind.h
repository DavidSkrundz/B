#pragma once

extern int ExpressionKind_Invalid;
extern int ExpressionKind_Group;
extern int ExpressionKind_Cast;
extern int ExpressionKind_Sizeof;
extern int ExpressionKind_Dereference;
extern int ExpressionKind_Reference;
extern int ExpressionKind_FunctionCall;
extern int ExpressionKind_Subscript;
extern int ExpressionKind_Arrow;
extern int ExpressionKind_InfixOperator;
extern int ExpressionKind_Identifier;
extern int ExpressionKind_NULL;
extern int ExpressionKind_BooleanLiteral;
extern int ExpressionKind_IntegerLiteral;
extern int ExpressionKind_StringLiteral;

void InitExpressionKinds(void);
