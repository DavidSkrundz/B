var TypespecKind_Invalid = 0;
var TypespecKind_Pointer = 0;
var TypespecKind_Identifier = 0;

func InitTypespecKinds() {
	var counter = 0;
	
	TypespecKind_Invalid = counter; counter = counter + 1;
	TypespecKind_Pointer = counter; counter = counter + 1;
	TypespecKind_Identifier = counter; counter = counter + 1;
};
