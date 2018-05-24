#include "TokenKind.h"

int TokenKind_Invalid;
int TokenKind_EOF;
int TokenKind_NULL;

int TokenKind_Sizeof;

int TokenKind_Var;
int TokenKind_Func;
int TokenKind_Struct;

int TokenKind_If;
int TokenKind_Else;
int TokenKind_While;
int TokenKind_Return;

int TokenKind_Comma;
int TokenKind_Colon;
int TokenKind_Semicolon;
int TokenKind_OpenCurly;
int TokenKind_CloseCurly;
int TokenKind_OpenBracket;
int TokenKind_CloseBracket;
int TokenKind_OpenParenthesis;
int TokenKind_CloseParenthesis;

int TokenKind_At;
int TokenKind_Star;
int TokenKind_And;
int TokenKind_Assign;
int TokenKind_Ellipses;
int TokenKind_Arrow;

int TokenKind_AndAnd;
int TokenKind_OrOr;

int TokenKind_Plus;
int TokenKind_Minus;
int TokenKind_Slash;
int TokenKind_Not;
int TokenKind_Equal;
int TokenKind_LessThan;
int TokenKind_NotEqual;

int TokenKind_Identifier;
int TokenKind_BooleanLiteral;
int TokenKind_IntegerLiteral;
int TokenKind_StringLiteral;

void InitTokenKinds(void) {
	int counter = 0;
	
	TokenKind_Invalid = counter++;
	TokenKind_EOF = counter++;
	TokenKind_NULL = counter++;
	
	TokenKind_Sizeof = counter++;
	
	TokenKind_Var = counter++;
	TokenKind_Func = counter++;
	TokenKind_Struct = counter++;
	
	TokenKind_If = counter++;
	TokenKind_Else = counter++;
	TokenKind_While = counter++;
	TokenKind_Return = counter++;
	
	TokenKind_Comma = counter++;
	TokenKind_Colon = counter++;
	TokenKind_Semicolon = counter++;
	TokenKind_OpenCurly = counter++;
	TokenKind_CloseCurly = counter++;
	TokenKind_OpenBracket = counter++;
	TokenKind_CloseBracket = counter++;
	TokenKind_OpenParenthesis = counter++;
	TokenKind_CloseParenthesis = counter++;
	
	TokenKind_At = counter++;
	TokenKind_Star = counter++;
	TokenKind_And = counter++;
	TokenKind_Assign = counter++;
	TokenKind_Ellipses = counter++;
	TokenKind_Arrow = counter++;
	
	TokenKind_AndAnd = counter++;
	TokenKind_OrOr = counter++;
	
	TokenKind_Plus = counter++;
	TokenKind_Minus = counter++;
	TokenKind_Slash = counter++;
	TokenKind_Not = counter++;
	TokenKind_Equal = counter++;
	TokenKind_LessThan = counter++;
	TokenKind_NotEqual = counter++;
	
	TokenKind_Identifier = counter++;
	TokenKind_BooleanLiteral = counter++;
	TokenKind_IntegerLiteral = counter++;
	TokenKind_StringLiteral = counter++;
}
