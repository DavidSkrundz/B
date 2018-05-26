var TypeKind_Invalid = 0;
var TypeKind_Identifier = 0;
var TypeKind_Pointer = 0;
var TypeKind_Function = 0;

func InitTypeKinds() {
	var counter = 0;
	
	TypeKind_Invalid = counter; counter = counter + 1;
	TypeKind_Identifier = counter; counter = counter + 1;
	TypeKind_Pointer = counter; counter = counter + 1;
	TypeKind_Function = counter; counter = counter + 1;
};
