var StatementKind_Invalid = 0;
var StatementKind_Block = 0;
var StatementKind_Expression = 0;
var StatementKind_Assign = 0;

var StatementKind_Var = 0;
var StatementKind_If = 0;
var StatementKind_While = 0;
var StatementKind_Return = 0;

func InitStatementKinds() {
	var counter = 0;
	
	StatementKind_Invalid = counter; counter = counter + 1;
	StatementKind_Block = counter; counter = counter + 1;
	StatementKind_Expression = counter; counter = counter + 1;
	StatementKind_Assign = counter; counter = counter + 1;
	
	StatementKind_Var = counter; counter = counter + 1;
	StatementKind_If = counter; counter = counter + 1;
	StatementKind_While = counter; counter = counter + 1;
	StatementKind_Return = counter; counter = counter + 1;
};
