var ExpressionKind_Invalid = (UInt)0;
var ExpressionKind_Group = (UInt)0;
var ExpressionKind_Cast = (UInt)0;
var ExpressionKind_Sizeof = (UInt)0;
var ExpressionKind_Dereference = (UInt)0;
var ExpressionKind_Reference = (UInt)0;
var ExpressionKind_FunctionCall = (UInt)0;
var ExpressionKind_Subscript = (UInt)0;
var ExpressionKind_Arrow = (UInt)0;
var ExpressionKind_InfixOperator = (UInt)0;
var ExpressionKind_Identifier = (UInt)0;
var ExpressionKind_NULL = (UInt)0;
var ExpressionKind_BooleanLiteral = (UInt)0;
var ExpressionKind_IntegerLiteral = (UInt)0;
var ExpressionKind_StringLiteral = (UInt)0;

func InitExpressionKinds() {
	var counter = (UInt)0;
	
	ExpressionKind_Invalid = counter; counter = counter + (UInt)1;
	ExpressionKind_Group = counter; counter = counter + (UInt)1;
	ExpressionKind_Cast = counter; counter = counter + (UInt)1;
	ExpressionKind_Sizeof = counter; counter = counter + (UInt)1;
	ExpressionKind_Dereference = counter; counter = counter + (UInt)1;
	ExpressionKind_Reference = counter; counter = counter + (UInt)1;
	ExpressionKind_FunctionCall = counter; counter = counter + (UInt)1;
	ExpressionKind_Subscript = counter; counter = counter + (UInt)1;
	ExpressionKind_Arrow = counter; counter = counter + (UInt)1;
	ExpressionKind_InfixOperator = counter; counter = counter + (UInt)1;
	ExpressionKind_Identifier = counter; counter = counter + (UInt)1;
	ExpressionKind_NULL = counter; counter = counter + (UInt)1;
	ExpressionKind_BooleanLiteral = counter; counter = counter + (UInt)1;
	ExpressionKind_IntegerLiteral = counter; counter = counter + (UInt)1;
	ExpressionKind_StringLiteral = counter; counter = counter + (UInt)1;
};
