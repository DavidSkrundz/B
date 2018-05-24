#pragma once

extern int TokenKind_Invalid;
extern int TokenKind_EOF;
extern int TokenKind_NULL;

extern int TokenKind_Sizeof;

extern int TokenKind_Var;
extern int TokenKind_Func;
extern int TokenKind_Struct;

extern int TokenKind_If;
extern int TokenKind_Else;
extern int TokenKind_While;
extern int TokenKind_Return;

extern int TokenKind_Comma;
extern int TokenKind_Colon;
extern int TokenKind_Semicolon;
extern int TokenKind_OpenCurly;
extern int TokenKind_CloseCurly;
extern int TokenKind_OpenBracket;
extern int TokenKind_CloseBracket;
extern int TokenKind_OpenParenthesis;
extern int TokenKind_CloseParenthesis;

extern int TokenKind_At;
extern int TokenKind_Star;
extern int TokenKind_And;
extern int TokenKind_Assign;
extern int TokenKind_Ellipses;
extern int TokenKind_Arrow;

extern int TokenKind_AndAnd;
extern int TokenKind_OrOr;

extern int TokenKind_Plus;
extern int TokenKind_Minus;
extern int TokenKind_Slash;
extern int TokenKind_Not;
extern int TokenKind_Equal;
extern int TokenKind_LessThan;
extern int TokenKind_NotEqual;

extern int TokenKind_Identifier;
extern int TokenKind_BooleanLiteral;
extern int TokenKind_IntegerLiteral;
extern int TokenKind_StringLiteral;

void InitTokenKinds(void);
