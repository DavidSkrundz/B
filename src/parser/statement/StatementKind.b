var StatementKind_Invalid = (UInt)0;
var StatementKind_Block = (UInt)0;
var StatementKind_Expression = (UInt)0;
var StatementKind_Assign = (UInt)0;

var StatementKind_Var = (UInt)0;
var StatementKind_If = (UInt)0;
var StatementKind_While = (UInt)0;
var StatementKind_Return = (UInt)0;

func InitStatementKinds() {
	var counter = (UInt)0;
	
	StatementKind_Invalid = counter; counter = counter + (UInt)1;
	StatementKind_Block = counter; counter = counter + (UInt)1;
	StatementKind_Expression = counter; counter = counter + (UInt)1;
	StatementKind_Assign = counter; counter = counter + (UInt)1;
	
	StatementKind_Var = counter; counter = counter + (UInt)1;
	StatementKind_If = counter; counter = counter + (UInt)1;
	StatementKind_While = counter; counter = counter + (UInt)1;
	StatementKind_Return = counter; counter = counter + (UInt)1;
};
