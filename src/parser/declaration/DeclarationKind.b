var DeclarationKind_Invalid = 0;
var DeclarationKind_Var = 0;
var DeclarationKind_Func = 0;
var DeclarationKind_Struct = 0;
var DeclarationKind_Enum = 0;

func InitDeclarationKinds() {
	var counter = 0;
	
	DeclarationKind_Invalid = counter; counter = counter + 1;
	DeclarationKind_Var = counter; counter = counter + 1;
	DeclarationKind_Func = counter; counter = counter + 1;
	DeclarationKind_Struct = counter; counter = counter + 1;
	DeclarationKind_Enum = counter; counter = counter + 1;
};
