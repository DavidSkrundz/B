var DeclarationKind_Invalid = (UInt)0;
var DeclarationKind_Var = (UInt)0;
var DeclarationKind_Func = (UInt)0;
var DeclarationKind_Struct = (UInt)0;

func InitDeclarationKinds() {
	var counter = (UInt)0;
	
	DeclarationKind_Invalid = counter; counter = counter + (UInt)1;
	DeclarationKind_Var = counter; counter = counter + (UInt)1;
	DeclarationKind_Func = counter; counter = counter + (UInt)1;
	DeclarationKind_Struct = counter; counter = counter + (UInt)1;
};
