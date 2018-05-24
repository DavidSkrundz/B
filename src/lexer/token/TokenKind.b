var TokenKind_Invalid = (UInt)0;
var TokenKind_EOF = (UInt)0;
var TokenKind_NULL = (UInt)0;

var TokenKind_Sizeof = (UInt)0;

var TokenKind_Var = (UInt)0;
var TokenKind_Func = (UInt)0;
var TokenKind_Struct = (UInt)0;

var TokenKind_If = (UInt)0;
var TokenKind_Else = (UInt)0;
var TokenKind_While = (UInt)0;
var TokenKind_Return = (UInt)0;

var TokenKind_Comma = (UInt)0;
var TokenKind_Colon = (UInt)0;
var TokenKind_Semicolon = (UInt)0;
var TokenKind_OpenCurly = (UInt)0;
var TokenKind_CloseCurly = (UInt)0;
var TokenKind_OpenBracket = (UInt)0;
var TokenKind_CloseBracket = (UInt)0;
var TokenKind_OpenParenthesis = (UInt)0;
var TokenKind_CloseParenthesis = (UInt)0;

var TokenKind_At = (UInt)0;
var TokenKind_Star = (UInt)0;
var TokenKind_And = (UInt)0;
var TokenKind_Assign = (UInt)0;
var TokenKind_Ellipses = (UInt)0;
var TokenKind_Arrow = (UInt)0;

var TokenKind_AndAnd = (UInt)0;
var TokenKind_OrOr = (UInt)0;

var TokenKind_Plus = (UInt)0;
var TokenKind_Minus = (UInt)0;
var TokenKind_Slash = (UInt)0;
var TokenKind_Not = (UInt)0;
var TokenKind_Equal = (UInt)0;
var TokenKind_LessThan = (UInt)0;
var TokenKind_NotEqual = (UInt)0;

var TokenKind_Identifier = (UInt)0;
var TokenKind_BooleanLiteral = (UInt)0;
var TokenKind_IntegerLiteral = (UInt)0;
var TokenKind_StringLiteral = (UInt)0;

func InitTokenKinds() {
	var counter = (UInt)0;
	
	TokenKind_Invalid = counter; counter = counter + (UInt)1;
	TokenKind_EOF = counter; counter = counter + (UInt)1;
	TokenKind_NULL = counter; counter = counter + (UInt)1;
	
	TokenKind_Sizeof = counter; counter = counter + (UInt)1;
	
	TokenKind_Var = counter; counter = counter + (UInt)1;
	TokenKind_Func = counter; counter = counter + (UInt)1;
	TokenKind_Struct = counter; counter = counter + (UInt)1;
	
	TokenKind_If = counter; counter = counter + (UInt)1;
	TokenKind_Else = counter; counter = counter + (UInt)1;
	TokenKind_While = counter; counter = counter + (UInt)1;
	TokenKind_Return = counter; counter = counter + (UInt)1;
	
	TokenKind_Comma = counter; counter = counter + (UInt)1;
	TokenKind_Colon = counter; counter = counter + (UInt)1;
	TokenKind_Semicolon = counter; counter = counter + (UInt)1;
	TokenKind_OpenCurly = counter; counter = counter + (UInt)1;
	TokenKind_CloseCurly = counter; counter = counter + (UInt)1;
	TokenKind_OpenBracket = counter; counter = counter + (UInt)1;
	TokenKind_CloseBracket = counter; counter = counter + (UInt)1;
	TokenKind_OpenParenthesis = counter; counter = counter + (UInt)1;
	TokenKind_CloseParenthesis = counter; counter = counter + (UInt)1;
	
	TokenKind_At = counter; counter = counter + (UInt)1;
	TokenKind_Star = counter; counter = counter + (UInt)1;
	TokenKind_And = counter; counter = counter + (UInt)1;
	TokenKind_Assign = counter; counter = counter + (UInt)1;
	TokenKind_Ellipses = counter; counter = counter + (UInt)1;
	TokenKind_Arrow = counter; counter = counter + (UInt)1;
	
	TokenKind_AndAnd = counter; counter = counter + (UInt)1;
	TokenKind_OrOr = counter; counter = counter + (UInt)1;
	
	TokenKind_Plus = counter; counter = counter + (UInt)1;
	TokenKind_Minus = counter; counter = counter + (UInt)1;
	TokenKind_Slash = counter; counter = counter + (UInt)1;
	TokenKind_Not = counter; counter = counter + (UInt)1;
	TokenKind_Equal = counter; counter = counter + (UInt)1;
	TokenKind_LessThan = counter; counter = counter + (UInt)1;
	TokenKind_NotEqual = counter; counter = counter + (UInt)1;
	
	TokenKind_Identifier = counter; counter = counter + (UInt)1;
	TokenKind_BooleanLiteral = counter; counter = counter + (UInt)1;
	TokenKind_IntegerLiteral = counter; counter = counter + (UInt)1;
	TokenKind_StringLiteral = counter; counter = counter + (UInt)1;
};
