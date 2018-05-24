var TypespecKind_Invalid = (UInt)0;
var TypespecKind_Pointer = (UInt)0;
var TypespecKind_Identifier = (UInt)0;

func InitTypespecKinds() {
	var counter = (UInt)0;
	
	TypespecKind_Invalid = counter; counter = counter + (UInt)1;
	TypespecKind_Pointer = counter; counter = counter + (UInt)1;
	TypespecKind_Identifier = counter; counter = counter + (UInt)1;
};
