var TypeKind_Invalid = (UInt)0;
var TypeKind_Identifier = (UInt)0;
var TypeKind_Pointer = (UInt)0;
var TypeKind_Function = (UInt)0;

func InitTypeKinds() {
	var counter = (UInt)0;
	
	TypeKind_Invalid = counter; counter = counter + (UInt)1;
	TypeKind_Identifier = counter; counter = counter + (UInt)1;
	TypeKind_Pointer = counter; counter = counter + (UInt)1;
	TypeKind_Function = counter; counter = counter + (UInt)1;
};
