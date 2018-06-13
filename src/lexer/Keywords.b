var Keyword_NULL: UInt8*;
var Keyword_Sizeof: UInt8*;
var Keyword_Offsetof: UInt8*;
var Keyword_Var: UInt8*;
var Keyword_Func: UInt8*;
var Keyword_Struct: UInt8*;
var Keyword_Enum: UInt8*;
var Keyword_If: UInt8*;
var Keyword_Else: UInt8*;
var Keyword_While: UInt8*;
var Keyword_Return: UInt8*;
var Keyword_Case: UInt8*;
var Keyword_True: UInt8*;
var Keyword_False: UInt8*;

func InternKeywords() {
	Keyword_NULL = internLiteral("NULL");
	Keyword_Sizeof = internLiteral("sizeof");
	Keyword_Offsetof = internLiteral("offsetof");
	Keyword_Var = internLiteral("var");
	Keyword_Func = internLiteral("func");
	Keyword_Struct = internLiteral("struct");
	Keyword_Enum = internLiteral("enum");
	Keyword_If = internLiteral("if");
	Keyword_Else = internLiteral("else");
	Keyword_While = internLiteral("while");
	Keyword_Return = internLiteral("return");
	Keyword_Case = internLiteral("case");
	Keyword_True = internLiteral("true");
	Keyword_False = internLiteral("false");
};