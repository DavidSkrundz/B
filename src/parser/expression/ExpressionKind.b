var ExpressionKind_Invalid = 0;
var ExpressionKind_Group = 0;
var ExpressionKind_Cast = 0;
var ExpressionKind_Sizeof = 0;
var ExpressionKind_Dereference = 0;
var ExpressionKind_Reference = 0;
var ExpressionKind_FunctionCall = 0;
var ExpressionKind_Subscript = 0;
var ExpressionKind_Arrow = 0;
var ExpressionKind_InfixOperator = 0;
var ExpressionKind_Identifier = 0;
var ExpressionKind_NULL = 0;
var ExpressionKind_BooleanLiteral = 0;
var ExpressionKind_IntegerLiteral = 0;
var ExpressionKind_StringLiteral = 0;

func InitExpressionKinds() {
	var counter = 0;
	
	ExpressionKind_Invalid = counter; counter = counter + 1;
	ExpressionKind_Group = counter; counter = counter + 1;
	ExpressionKind_Cast = counter; counter = counter + 1;
	ExpressionKind_Sizeof = counter; counter = counter + 1;
	ExpressionKind_Dereference = counter; counter = counter + 1;
	ExpressionKind_Reference = counter; counter = counter + 1;
	ExpressionKind_FunctionCall = counter; counter = counter + 1;
	ExpressionKind_Subscript = counter; counter = counter + 1;
	ExpressionKind_Arrow = counter; counter = counter + 1;
	ExpressionKind_InfixOperator = counter; counter = counter + 1;
	ExpressionKind_Identifier = counter; counter = counter + 1;
	ExpressionKind_NULL = counter; counter = counter + 1;
	ExpressionKind_BooleanLiteral = counter; counter = counter + 1;
	ExpressionKind_IntegerLiteral = counter; counter = counter + 1;
	ExpressionKind_StringLiteral = counter; counter = counter + 1;
};
