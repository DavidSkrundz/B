var DeclarationState_Invalid = (UInt)0;
var DeclarationState_Unresolved = (UInt)0;
var DeclarationState_Resolving = (UInt)0;
var DeclarationState_Resolved = (UInt)0;

func InitDeclarationStates() {
	var counter = (UInt)0;
	
	DeclarationState_Invalid = counter; counter = counter + (UInt)1;
	DeclarationState_Unresolved = counter; counter = counter + (UInt)1;
	DeclarationState_Resolving = counter; counter = counter + (UInt)1;
	DeclarationState_Resolved = counter; counter = counter + (UInt)1;
};
