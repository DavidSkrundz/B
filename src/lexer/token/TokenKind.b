var TokenKind_Invalid = 0;
var TokenKind_EOF = 0;
var TokenKind_NULL = 0;

var TokenKind_Sizeof = 0;
var TokenKind_Offsetof = 0;

var TokenKind_Var = 0;
var TokenKind_Func = 0;
var TokenKind_Struct = 0;
var TokenKind_Enum = 0;

var TokenKind_If = 0;
var TokenKind_Else = 0;
var TokenKind_While = 0;
var TokenKind_Return = 0;
var TokenKind_Case = 0;

var TokenKind_Comma = 0;
var TokenKind_Colon = 0;
var TokenKind_Semicolon = 0;
var TokenKind_OpenCurly = 0;
var TokenKind_CloseCurly = 0;
var TokenKind_OpenBracket = 0;
var TokenKind_CloseBracket = 0;
var TokenKind_OpenParenthesis = 0;
var TokenKind_CloseParenthesis = 0;

var TokenKind_At = 0;
var TokenKind_Star = 0;
var TokenKind_And = 0;
var TokenKind_Assign = 0;
var TokenKind_Ellipses = 0;
var TokenKind_Arrow = 0;
var TokenKind_Dot = 0;

var TokenKind_AndAnd = 0;
var TokenKind_OrOr = 0;

var TokenKind_Plus = 0;
var TokenKind_Minus = 0;
var TokenKind_Slash = 0;
var TokenKind_Not = 0;
var TokenKind_Equal = 0;
var TokenKind_LessThan = 0;
var TokenKind_LessThanEqual = 0;
var TokenKind_NotEqual = 0;

var TokenKind_Identifier = 0;
var TokenKind_BooleanLiteral = 0;
var TokenKind_IntegerLiteral = 0;
var TokenKind_CharacterLiteral = 0;
var TokenKind_StringLiteral = 0;

func InitTokenKinds() {
	var counter = 0;
	
	TokenKind_Invalid = counter; counter = counter + 1;
	TokenKind_EOF = counter; counter = counter + 1;
	TokenKind_NULL = counter; counter = counter + 1;
	
	TokenKind_Sizeof = counter; counter = counter + 1;
	TokenKind_Offsetof = counter; counter = counter + 1;
	
	TokenKind_Var = counter; counter = counter + 1;
	TokenKind_Func = counter; counter = counter + 1;
	TokenKind_Struct = counter; counter = counter + 1;
	TokenKind_Enum = counter; counter = counter + 1;
	
	TokenKind_If = counter; counter = counter + 1;
	TokenKind_Else = counter; counter = counter + 1;
	TokenKind_While = counter; counter = counter + 1;
	TokenKind_Return = counter; counter = counter + 1;
	TokenKind_Case = counter; counter = counter + 1;
	
	TokenKind_Comma = counter; counter = counter + 1;
	TokenKind_Colon = counter; counter = counter + 1;
	TokenKind_Semicolon = counter; counter = counter + 1;
	TokenKind_OpenCurly = counter; counter = counter + 1;
	TokenKind_CloseCurly = counter; counter = counter + 1;
	TokenKind_OpenBracket = counter; counter = counter + 1;
	TokenKind_CloseBracket = counter; counter = counter + 1;
	TokenKind_OpenParenthesis = counter; counter = counter + 1;
	TokenKind_CloseParenthesis = counter; counter = counter + 1;
	
	TokenKind_At = counter; counter = counter + 1;
	TokenKind_Star = counter; counter = counter + 1;
	TokenKind_And = counter; counter = counter + 1;
	TokenKind_Assign = counter; counter = counter + 1;
	TokenKind_Ellipses = counter; counter = counter + 1;
	TokenKind_Arrow = counter; counter = counter + 1;
	TokenKind_Dot = counter; counter = counter + 1;
	
	TokenKind_AndAnd = counter; counter = counter + 1;
	TokenKind_OrOr = counter; counter = counter + 1;
	
	TokenKind_Plus = counter; counter = counter + 1;
	TokenKind_Minus = counter; counter = counter + 1;
	TokenKind_Slash = counter; counter = counter + 1;
	TokenKind_Not = counter; counter = counter + 1;
	TokenKind_Equal = counter; counter = counter + 1;
	TokenKind_LessThan = counter; counter = counter + 1;
	TokenKind_LessThanEqual = counter; counter = counter + 1;
	TokenKind_NotEqual = counter; counter = counter + 1;
	
	TokenKind_Identifier = counter; counter = counter + 1;
	TokenKind_BooleanLiteral = counter; counter = counter + 1;
	TokenKind_IntegerLiteral = counter; counter = counter + 1;
	TokenKind_CharacterLiteral = counter; counter = counter + 1;
	TokenKind_StringLiteral = counter; counter = counter + 1;
};
